"""Defines the dependencies required for the Swift Rule Engine library."""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")


def swift_rule_engine_dependencies():
    maybe(git_repository,
        name = "SwiftSyntax",
        tag = "600.0.1",
        remote = "https://github.com/apple/swift-syntax.git",
    )
