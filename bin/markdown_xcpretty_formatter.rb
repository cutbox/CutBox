require 'xcpretty'

class Markdown < XCPretty::Simple

  def format_test_run_started(name)
    "\n\n# Started: #{name}\n\n| Status | Name |\n|:-----|:-----|\n"
  end

  def format_test_suite_started(name)
    if name != "All tests"
      "| - | #{name} |"
    else
      ""
    end
  end

  def format_passing_test(suite, test_case, time)
    "| ✓ | #{suite} #{test_case} (#{time}) |"
  end


  def format_failing_test(suite, test, reason, file_path)
    "| ✗ | #{suite} #{test}  |\n|   | #{file_path}      |\n|   | Reason: #{reason} |"
  end

  # You can add more methods to format different events as needed

  private

  def format_duration(duration)
    "%.2f seconds" % duration
  end
end

Markdown
