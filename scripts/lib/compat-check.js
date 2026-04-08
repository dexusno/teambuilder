#!/usr/bin/env node
// =============================================================================
// TeamBuilder Compatibility Check
// =============================================================================
//
// Reads `<bmad>/teambuilder/compatibility.json` and probes the live BMAD
// install at `<bmad>/` for required structure, schema invariants, and
// version compatibility.
//
// Vanilla Node — zero dependencies. Uses only fs, path, process from stdlib.
//
// Usage:
//   node compat-check.js [--bmad-path <path>] [--strict] [--json]
//
// Flags:
//   --bmad-path <path>   Path to the project root containing _bmad/
//                        Default: process.cwd()
//   --strict             Exit 1 on warnings (default: only on failures)
//   --json               Emit machine-readable JSON output
//   --quiet              Suppress per-check output (only summary)
//   -h, --help           Show this help
//
// Exit codes:
//   0 = healthy (or warnings in non-strict mode)
//   1 = failures detected (or warnings in strict mode)
//   2 = could not run check (compatibility.json missing, BMAD missing)
// =============================================================================

'use strict';

const fs = require('fs');
const path = require('path');

// -----------------------------------------------------------------------------
// Argument parsing (vanilla, no commander)
// -----------------------------------------------------------------------------
function parseArgs(argv) {
    const opts = {
        bmadPath: process.cwd(),
        strict: false,
        json: false,
        quiet: false,
        help: false
    };
    for (let i = 2; i < argv.length; i++) {
        const a = argv[i];
        if (a === '--bmad-path' && i + 1 < argv.length) {
            opts.bmadPath = argv[++i];
        } else if (a === '--strict') {
            opts.strict = true;
        } else if (a === '--json') {
            opts.json = true;
        } else if (a === '--quiet') {
            opts.quiet = true;
        } else if (a === '-h' || a === '--help') {
            opts.help = true;
        } else {
            console.error('Unknown argument: ' + a);
            opts.help = true;
        }
    }
    return opts;
}

function printHelp() {
    const lines = [
        'TeamBuilder Compatibility Check',
        '',
        'Usage:',
        '  node compat-check.js [--bmad-path <path>] [--strict] [--json] [--quiet]',
        '',
        'Flags:',
        '  --bmad-path <path>   Project root containing _bmad/ (default: cwd)',
        '  --strict             Exit 1 on warnings as well as failures',
        '  --json               Emit JSON output instead of human-readable text',
        '  --quiet              Suppress per-check output',
        '  -h, --help           Show this help',
        '',
        'Exit codes:',
        '  0 = healthy',
        '  1 = failures (or warnings if --strict)',
        '  2 = cannot run (compatibility.json missing or BMAD missing)'
    ];
    console.log(lines.join('\n'));
}

// -----------------------------------------------------------------------------
// Console helpers (ANSI colors when TTY, plain otherwise)
// -----------------------------------------------------------------------------
const isTty = process.stdout.isTTY;
const C = {
    reset: isTty ? '\x1b[0m' : '',
    bold: isTty ? '\x1b[1m' : '',
    cyan: isTty ? '\x1b[36m' : '',
    green: isTty ? '\x1b[32m' : '',
    red: isTty ? '\x1b[31m' : '',
    yellow: isTty ? '\x1b[33m' : '',
    gray: isTty ? '\x1b[90m' : ''
};

// -----------------------------------------------------------------------------
// Tiny semver subset (just enough to compare X.Y.Z and check ranges like
// ">=6.2.2 <6.3.0"). No prerelease handling — for that, treat as untested.
// -----------------------------------------------------------------------------
function parseVersion(v) {
    if (!v || typeof v !== 'string') return null;
    // Strip any leading 'v' and prerelease tag
    const cleaned = v.replace(/^v/, '').split(/[-+]/)[0];
    const parts = cleaned.split('.').map(function (n) { return parseInt(n, 10); });
    if (parts.length < 3 || parts.some(isNaN)) return null;
    return { major: parts[0], minor: parts[1], patch: parts[2], prerelease: v.includes('-') };
}

function compareVersions(a, b) {
    if (a.major !== b.major) return a.major - b.major;
    if (a.minor !== b.minor) return a.minor - b.minor;
    return a.patch - b.patch;
}

function satisfiesRange(version, range) {
    // Supports: ">=X.Y.Z <X.Y.Z" or ">X.Y.Z" or "<X.Y.Z" or "=X.Y.Z" or "X.Y.Z"
    const v = parseVersion(version);
    if (!v) return false;
    const constraints = range.trim().split(/\s+/);
    for (let i = 0; i < constraints.length; i++) {
        const c = constraints[i];
        const m = c.match(/^(>=|<=|>|<|=)?(\d+\.\d+\.\d+)$/);
        if (!m) continue;
        const op = m[1] || '=';
        const target = parseVersion(m[2]);
        if (!target) return false;
        const cmp = compareVersions(v, target);
        if (op === '>=' && cmp < 0) return false;
        if (op === '<=' && cmp > 0) return false;
        if (op === '>' && cmp <= 0) return false;
        if (op === '<' && cmp >= 0) return false;
        if (op === '=' && cmp !== 0) return false;
    }
    return true;
}

// -----------------------------------------------------------------------------
// CSV header reader (vanilla, handles standard quoted CSV)
// -----------------------------------------------------------------------------
function readCsvHeader(filePath) {
    if (!fs.existsSync(filePath)) return null;
    const content = fs.readFileSync(filePath, 'utf8');
    const firstLine = content.split(/\r?\n/)[0];
    if (!firstLine) return [];
    // Simple CSV header parse (no embedded commas in column names expected)
    return firstLine.split(',').map(function (s) { return s.trim().replace(/^"|"$/g, ''); });
}

function readCsvRowCount(filePath, modulePattern) {
    if (!fs.existsSync(filePath)) return 0;
    const lines = fs.readFileSync(filePath, 'utf8').split(/\r?\n/);
    let count = 0;
    for (let i = 1; i < lines.length; i++) {
        if (lines[i] && (!modulePattern || lines[i].indexOf(modulePattern) !== -1)) count++;
    }
    return count;
}

// -----------------------------------------------------------------------------
// Naive YAML reader for top-level keys (vanilla, no js-yaml dep)
// Just enough to confirm the BMAD version line in manifest.yaml.
// -----------------------------------------------------------------------------
function readManifestYaml(filePath) {
    if (!fs.existsSync(filePath)) return null;
    const lines = fs.readFileSync(filePath, 'utf8').split(/\r?\n/);
    const out = { topKeys: [], installation_version: null, modules: [] };
    let currentSection = null;
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        // Top-level key (no leading whitespace, ends with colon)
        const m = line.match(/^([a-zA-Z_][a-zA-Z0-9_]*)\s*:/);
        if (m) {
            out.topKeys.push(m[1]);
            currentSection = m[1];
            continue;
        }
        // Track installation.version
        if (currentSection === 'installation') {
            const v = line.match(/^\s+version:\s*(\S+)/);
            if (v) out.installation_version = v[1].replace(/['"]/g, '');
        }
        // Track module names (very loose: lines like "  - name: bmm")
        if (currentSection === 'modules') {
            const n = line.match(/^\s+-\s+name:\s*(\S+)/);
            if (n) out.modules.push(n[1].replace(/['"]/g, ''));
        }
    }
    return out;
}

// -----------------------------------------------------------------------------
// Check runner
// -----------------------------------------------------------------------------
function makeChecker() {
    const checks = [];
    return {
        add: function (section, name, status, detail) {
            checks.push({ section: section, name: name, status: status, detail: detail || '' });
        },
        list: function () { return checks; },
        countByStatus: function (status) {
            return checks.filter(function (c) { return c.status === status; }).length;
        }
    };
}

// -----------------------------------------------------------------------------
// Main
// -----------------------------------------------------------------------------
function main() {
    const opts = parseArgs(process.argv);
    if (opts.help) { printHelp(); process.exit(0); }

    const projectRoot = path.resolve(opts.bmadPath);
    const bmadDir = path.join(projectRoot, '_bmad');
    const compatPath = path.join(bmadDir, 'teambuilder', 'compatibility.json');

    // Hard precondition: compatibility.json must exist
    if (!fs.existsSync(compatPath)) {
        const msg = 'compatibility.json not found at ' + compatPath;
        if (opts.json) {
            console.log(JSON.stringify({ error: msg, exitCode: 2 }, null, 2));
        } else {
            console.error(C.red + '[X] ' + msg + C.reset);
            console.error(C.gray + '    Either TeamBuilder is not installed in this project, or this is an older' + C.reset);
            console.error(C.gray + '    TeamBuilder install (pre-3.1) without the compatibility manifest.' + C.reset);
            console.error(C.gray + '    Run scripts/install.* to install or upgrade.' + C.reset);
        }
        process.exit(2);
    }

    let compat;
    try {
        compat = JSON.parse(fs.readFileSync(compatPath, 'utf8'));
    } catch (e) {
        console.error(C.red + '[X] Failed to parse compatibility.json: ' + e.message + C.reset);
        process.exit(2);
    }

    const checker = makeChecker();

    // -------------------------------------------------------------------------
    // Section A — BMAD version status
    // -------------------------------------------------------------------------
    const manifest = readManifestYaml(path.join(bmadDir, '_config', 'manifest.yaml'));
    const detectedBmadVersion = manifest && manifest.installation_version ? manifest.installation_version : null;

    if (!detectedBmadVersion) {
        checker.add('A', 'detect BMAD version', 'FAIL', 'manifest.yaml missing or installation.version not found');
    } else {
        checker.add('A', 'detect BMAD version', 'PASS', detectedBmadVersion);

        // Is it blocked?
        const blocked = (compat.bmad.blocked || []).find(function (b) { return b.version === detectedBmadVersion; });
        if (blocked) {
            checker.add('A', 'BMAD version not blocked', 'FAIL', 'BMAD ' + detectedBmadVersion + ' is BLOCKED: ' + blocked.reason);
        } else {
            // Is it tested?
            const tested = (compat.bmad.tested || []).find(function (t) { return t.version === detectedBmadVersion; });
            if (tested) {
                if (tested.status === 'pass') {
                    checker.add('A', 'BMAD version tested', 'PASS', 'tested ' + tested.tested_on + ' (' + tested.notes + ')');
                } else {
                    checker.add('A', 'BMAD version tested', 'WARN', 'tested ' + tested.tested_on + ' status=' + tested.status);
                }
            } else {
                // In supported range?
                if (satisfiesRange(detectedBmadVersion, compat.bmad.supported_range)) {
                    checker.add('A', 'BMAD version in range', 'WARN', detectedBmadVersion + ' is in ' + compat.bmad.supported_range + ' but has not been explicitly tested');
                } else {
                    checker.add('A', 'BMAD version in range', 'WARN', detectedBmadVersion + ' is OUTSIDE supported range ' + compat.bmad.supported_range);
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // Section B — BMAD structural invariants
    // -------------------------------------------------------------------------
    const reqStructure = compat.required_structure || {};
    (reqStructure.files || []).forEach(function (relPath) {
        const full = path.join(projectRoot, relPath);
        if (fs.existsSync(full)) {
            checker.add('B', relPath, 'PASS');
        } else {
            checker.add('B', relPath, 'FAIL', 'missing');
        }
    });
    (reqStructure.directories || []).forEach(function (relPath) {
        const full = path.join(projectRoot, relPath);
        if (fs.existsSync(full) && fs.statSync(full).isDirectory()) {
            checker.add('B', relPath + '/', 'PASS');
        } else {
            checker.add('B', relPath + '/', 'FAIL', 'missing');
        }
    });

    // CSV column header checks
    const csvChecks = [
        { file: '_bmad/_config/agent-manifest.csv',  expected: reqStructure.agent_manifest_columns,  label: 'agent-manifest.csv columns' },
        { file: '_bmad/_config/skill-manifest.csv',  expected: reqStructure.skill_manifest_columns,  label: 'skill-manifest.csv columns' },
        { file: '_bmad/_config/files-manifest.csv',  expected: reqStructure.files_manifest_columns,  label: 'files-manifest.csv columns' }
    ];
    csvChecks.forEach(function (c) {
        if (!c.expected) return;
        const fullPath = path.join(projectRoot, c.file);
        const actual = readCsvHeader(fullPath);
        if (!actual) {
            checker.add('B', c.label, 'FAIL', 'file missing');
            return;
        }
        // Compare as sets (order-tolerant) — BMAD may reorder columns
        const missing = c.expected.filter(function (col) { return actual.indexOf(col) === -1; });
        const extra = actual.filter(function (col) { return c.expected.indexOf(col) === -1; });
        if (missing.length === 0 && extra.length === 0) {
            checker.add('B', c.label, 'PASS', 'all ' + c.expected.length + ' columns match');
        } else if (missing.length > 0) {
            checker.add('B', c.label, 'FAIL', 'missing columns: ' + missing.join(', '));
        } else {
            // Extra columns are a warning, not a failure (BMAD added new fields)
            checker.add('B', c.label, 'WARN', 'extra columns present: ' + extra.join(', '));
        }
    });

    // manifest.yaml top-level keys
    if (manifest && reqStructure.manifest_yaml_top_keys) {
        reqStructure.manifest_yaml_top_keys.forEach(function (key) {
            if (manifest.topKeys.indexOf(key) !== -1) {
                checker.add('B', 'manifest.yaml has ' + key, 'PASS');
            } else {
                checker.add('B', 'manifest.yaml has ' + key, 'FAIL', 'top-level key missing');
            }
        });
    }

    // -------------------------------------------------------------------------
    // Section C — TeamBuilder install integrity
    // -------------------------------------------------------------------------
    const inv = compat.teambuilder_invariants || {};

    (inv.required_files || []).forEach(function (relPath) {
        const full = path.join(projectRoot, relPath);
        if (fs.existsSync(full)) {
            checker.add('C', relPath, 'PASS');
        } else {
            checker.add('C', relPath, 'FAIL', 'missing');
        }
    });

    // Expected agents
    (inv.expected_agents || []).forEach(function (agentName) {
        const agentDir = path.join(bmadDir, 'teambuilder', 'agents', agentName);
        const skillMd = path.join(agentDir, 'SKILL.md');
        const manifestYaml = path.join(agentDir, 'bmad-skill-manifest.yaml');
        if (fs.existsSync(skillMd) && fs.existsSync(manifestYaml)) {
            checker.add('C', 'agent ' + agentName, 'PASS');
        } else {
            checker.add('C', 'agent ' + agentName, 'FAIL', 'SKILL.md or bmad-skill-manifest.yaml missing');
        }
    });

    // Expected skills
    (inv.expected_skills || []).forEach(function (skillName) {
        const skillDir = path.join(bmadDir, 'teambuilder', 'skills', skillName);
        const skillMd = path.join(skillDir, 'SKILL.md');
        if (fs.existsSync(skillMd)) {
            checker.add('C', 'skill ' + skillName, 'PASS');
        } else {
            checker.add('C', 'skill ' + skillName, 'FAIL', 'SKILL.md missing');
        }
    });

    // Expected patterns
    (inv.expected_patterns || []).forEach(function (patternName) {
        const patternDir = path.join(bmadDir, 'teambuilder', 'patterns', patternName);
        if (fs.existsSync(patternDir) && fs.statSync(patternDir).isDirectory()) {
            const expectedFiles = ['metadata.yaml', 'pattern-overview.md', 'example-agents.md', 'example-workflows.md', 'collaboration-model.md', 'generation-guidance.md'];
            const missing = expectedFiles.filter(function (f) { return !fs.existsSync(path.join(patternDir, f)); });
            if (missing.length === 0) {
                checker.add('C', 'pattern ' + patternName, 'PASS', 'all 6 files present');
            } else {
                checker.add('C', 'pattern ' + patternName, 'WARN', 'missing files: ' + missing.join(', '));
            }
        } else {
            checker.add('C', 'pattern ' + patternName, 'FAIL', 'directory missing');
        }
    });

    // -------------------------------------------------------------------------
    // Section D — Manifest registration counts
    // -------------------------------------------------------------------------
    const tbAgentCount = readCsvRowCount(path.join(projectRoot, '_bmad', '_config', 'agent-manifest.csv'), '"teambuilder"');
    const tbSkillCount = readCsvRowCount(path.join(projectRoot, '_bmad', '_config', 'skill-manifest.csv'), '"teambuilder"');

    if (inv.expected_agent_count !== undefined) {
        if (tbAgentCount === inv.expected_agent_count) {
            checker.add('D', 'agent-manifest teambuilder rows', 'PASS', tbAgentCount + '/' + inv.expected_agent_count);
        } else {
            checker.add('D', 'agent-manifest teambuilder rows', 'FAIL', tbAgentCount + ' (expected ' + inv.expected_agent_count + ')');
        }
    }
    if (inv.expected_total_skill_manifest_rows !== undefined) {
        if (tbSkillCount === inv.expected_total_skill_manifest_rows) {
            checker.add('D', 'skill-manifest teambuilder rows', 'PASS', tbSkillCount + '/' + inv.expected_total_skill_manifest_rows);
        } else {
            checker.add('D', 'skill-manifest teambuilder rows', 'FAIL', tbSkillCount + ' (expected ' + inv.expected_total_skill_manifest_rows + ')');
        }
    }

    // teambuilder listed in manifest.yaml as a module
    if (manifest) {
        if (manifest.modules.indexOf('teambuilder') !== -1) {
            checker.add('D', 'teambuilder listed in manifest.yaml', 'PASS');
        } else {
            checker.add('D', 'teambuilder listed in manifest.yaml', 'FAIL', 'not found in modules list');
        }
    }

    // -------------------------------------------------------------------------
    // Output
    // -------------------------------------------------------------------------
    const passCount = checker.countByStatus('PASS');
    const warnCount = checker.countByStatus('WARN');
    const failCount = checker.countByStatus('FAIL');
    const totalCount = passCount + warnCount + failCount;

    let exitCode = 0;
    if (failCount > 0) exitCode = 1;
    else if (warnCount > 0 && opts.strict) exitCode = 1;

    let status;
    if (failCount > 0) status = 'FAIL';
    else if (warnCount > 0) status = 'WARN';
    else status = 'HEALTHY';

    if (opts.json) {
        const out = {
            status: status,
            exitCode: exitCode,
            counts: { pass: passCount, warn: warnCount, fail: failCount, total: totalCount },
            teambuilder_version: compat.teambuilder_version,
            bmad_version_detected: detectedBmadVersion,
            bmad_version_supported_range: compat.bmad.supported_range,
            checks: checker.list()
        };
        console.log(JSON.stringify(out, null, 2));
        process.exit(exitCode);
    }

    // Human-readable output
    if (!opts.quiet) {
        console.log(C.bold + C.cyan + 'TeamBuilder Compatibility Check' + C.reset);
        console.log(C.cyan + '================================' + C.reset);
        console.log('');
        console.log('  TeamBuilder version:      ' + compat.teambuilder_version);
        console.log('  BMAD version detected:    ' + (detectedBmadVersion || C.red + 'unknown' + C.reset));
        console.log('  BMAD supported range:     ' + compat.bmad.supported_range);
        console.log('');

        const sections = {
            A: 'A. BMAD version status',
            B: 'B. BMAD structural invariants',
            C: 'C. TeamBuilder install integrity',
            D: 'D. Manifest registration counts'
        };

        Object.keys(sections).forEach(function (sec) {
            const sectionChecks = checker.list().filter(function (c) { return c.section === sec; });
            if (sectionChecks.length === 0) return;
            console.log(C.bold + sections[sec] + C.reset);
            sectionChecks.forEach(function (c) {
                let icon, color;
                if (c.status === 'PASS') { icon = '[PASS]'; color = C.green; }
                else if (c.status === 'WARN') { icon = '[WARN]'; color = C.yellow; }
                else { icon = '[FAIL]'; color = C.red; }
                let line = '  ' + color + icon + C.reset + ' ' + c.name;
                if (c.detail) line += C.gray + '  (' + c.detail + ')' + C.reset;
                console.log(line);
            });
            console.log('');
        });

        console.log(C.cyan + '================================' + C.reset);
        console.log('  Result: ' + C.green + passCount + ' PASS' + C.reset + ', ' +
                                  C.yellow + warnCount + ' WARN' + C.reset + ', ' +
                                  C.red + failCount + ' FAIL' + C.reset);
        let statusColor = C.green;
        if (status === 'WARN') statusColor = C.yellow;
        if (status === 'FAIL') statusColor = C.red;
        console.log('  Status: ' + statusColor + C.bold + status + C.reset);
        console.log('');
    }

    process.exit(exitCode);
}

main();
