@runtime_extended
@runtime_extended3
Feature: Descriptor parsing and elaboration tests

  Scenario: Descriptor parsing
    Given an accepted node
    And a descriptor file is provided
    When the descriptor file is parsed as a cartridge
    Then the descriptor profile exists
    And atleast 1 component exists
