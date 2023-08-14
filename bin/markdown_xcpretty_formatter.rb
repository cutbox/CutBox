require 'xcpretty'

class Markdown < XCPretty::Simple

  def format_test_case_name(name)
    name = name.gsub(/(\d+)_(\d+)/, '\1.\2')
    name = name.gsub('_', ' ')
    name = name.gsub('__', ' : ')
    name = name.split(' : ').map(&:capitalize).join(' : ')
    name
  end

  def format_test_run_started(name)
    %{

# Started: #{name}

| - | Name |
|:-----|:-----|}
  end

  def format_test_suite_started(name)
    if name != "All tests"
      "| 🗎 | **#{name}** |"
    else
      ""
    end
  end

  def format_passing_test(suite, test_case, time)
    "| ✓ | #{format_test_case_name(test_case)} (#{time}) |"
  end


  def format_failing_test(suite, test_case, reason, file_path)
    %{| ✗ | #{format_test_case_name(test_case)} |
|   | #{file_path}      |
|   | Reason: #{reason} |}
  end

  private

  def format_duration(duration)
    "%.2f seconds" % duration
  end
end

Markdown
