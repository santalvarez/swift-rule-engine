load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library", "swift_test", "swift_compiler_plugin")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

# Main library target
swift_library(
    name = "SwiftRuleEngine",
    srcs = glob(["Sources/SwiftRuleEngine/**/*.swift"]),
    module_name = "SwiftRuleEngine",
    plugins = [":SwiftRuleEngineMacros"],
)

# Macros target
swift_compiler_plugin(
    name = "SwiftRuleEngineMacros",
    srcs = glob(["Sources/SwiftRuleEngineMacros/**/*.swift"]),
    deps = [
        "@SwiftSyntax//:SwiftSyntaxMacros",
        "@SwiftSyntax//:SwiftSyntax",
        "@SwiftSyntax//:SwiftSyntaxBuilder",
        "@SwiftSyntax//:SwiftCompilerPlugin",
    ],
    module_name = "SwiftRuleEngineMacros",
)

# Test targets
swift_test(
    name = "SwiftRuleEngineTests",
    srcs = glob(["Tests/SwiftRuleEngineTests/**/*.swift"]),
    deps = [":SwiftRuleEngine"],
    module_name = "SwiftRuleEngineTests",
)

swift_test(
    name = "SwiftRuleEngineMacrosTests",
    srcs = glob(["Tests/SwiftRuleEngineMacrosTests/**/*.swift"]),
    deps = [
        ":SwiftRuleEngineMacros",
        "@SwiftSyntax//:SwiftSyntaxMacrosTestSupport",
    ],
    module_name = "SwiftRuleEngineMacrosTests",
)

# Expose the deps.bzl file for other projects to use
bzl_library(
    name = "deps",
    srcs = ["deps.bzl"],
    visibility = ["//visibility:public"],
)
