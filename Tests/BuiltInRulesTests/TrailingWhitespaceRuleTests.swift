@testable import SwiftLintBuiltInRules
import TestHelpers

final class TrailingWhitespaceRuleTests: SwiftLintTestCase {
    func testWithIgnoresEmptyLinesEnabled() {
        // Perform additional tests with the ignores_empty_lines setting enabled.
        // The set of non-triggering examples is extended by a whitespace-indented empty line
        let baseDescription = TrailingWhitespaceRule.description
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples + [Example(" \n")]
        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)

        verifyRule(description,
                   ruleConfiguration: ["ignores_empty_lines": true, "ignores_comments": true])
    }

    func testWithIgnoresCommentsDisabled() {
        // Perform additional tests with the ignores_comments settings disabled.
        let baseDescription = TrailingWhitespaceRule.description
        let triggeringComments = [
            Example("// \n"),
            Example("let name: String // \n"),
        ]
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples
            .filter { !triggeringComments.contains($0) }
        let triggeringExamples = baseDescription.triggeringExamples + triggeringComments
        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
                                         .with(triggeringExamples: triggeringExamples)
        verifyRule(description,
                   ruleConfiguration: ["ignores_empty_lines": false, "ignores_comments": false],
                   commentDoesntViolate: false)
    }

    func testWithIgnoresLiteralsEnabled() {
        // Perform additional tests with the ignores_literals setting enabled.
        // This setting only ignores trailing whitespace inside multiline string literals.
        let baseDescription = TrailingWhitespaceRule.description
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples + [
            Example("let multiline = \"\"\"\n    content   \n    \"\"\"\n"),
        ]
        let triggeringExamples = baseDescription.triggeringExamples + [
            Example("let codeWithSpace = 123    \n"),
            Example("var number = 42   \n"),
        ]
        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
                                         .with(triggeringExamples: triggeringExamples)

        verifyRule(description,
                   ruleConfiguration: ["ignores_literals": true])
    }
}
