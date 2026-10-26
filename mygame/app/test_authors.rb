# Checks the repository's AUTHORS.txt: full name, CSU email, then @github-user.
#
# DragonRuby has neither Minitest nor Regexp, so the formats are checked by
# hand and the tests run with DragonRuby's own test runner, which calls every
# top-level method named test_* with (args, assert). From the top of the
# repository (use the binary for your platform):
#
#   ./dragonruby.macos mygame --test app/test_authors.rb --no-tick
#
# DragonRuby works on bytes, so any character outside of ASCII (é, ñ, ’ ...)
# counts as a letter in a name.

# Formats accepted in AUTHORS.txt.
module AuthorsFormat
  PATH = File.join(DR.get_base_dir, "AUTHORS.txt")
  README_EXAMPLE = ["Tuffy Titan", "tuffy@csu.fullerton.edu", "@tuffytitan"].freeze

  NAME_PUNCTUATION = [".", "'", "-"].freeze
  EMAIL_DOMAIN = "@csu.fullerton.edu".freeze
  EMAIL_SYMBOLS = [".", "_", "%", "+", "-"].freeze
  GITHUB_USER_MAX = 39

  # The file's lines with surrounding whitespace and trailing blank lines removed.
  def self.lines
    return [] unless File.exist?(PATH)

    # File.read returns nil in DragonRuby, so read line by line.
    lines = []
    File.foreach(PATH) { |line| lines << line.strip }
    lines.pop while lines.last == ""
    lines
  end

  def self.ascii_letter?(char)
    ("a".."z").cover?(char.downcase)
  end

  def self.digit?(char)
    ("0".."9").cover?(char)
  end

  def self.letter?(char)
    ascii_letter?(char) || char.ord >= 128
  end

  def self.alphanumeric?(char)
    ascii_letter?(char) || digit?(char)
  end

  # Two or more words separated by spaces. Each word starts with a letter and
  # may also hold periods (initials), apostrophes and hyphens, so middle names,
  # hyphenated surnames and multi-word surnames are all accepted.
  def self.name?(text)
    words = text.split
    text == text.strip && text.chars.all? { |c| c == " " || name_char?(c) } &&
      words.size >= 2 && words.all? { |word| letter?(word[0]) }
  end

  def self.name_char?(char)
    letter?(char) || NAME_PUNCTUATION.include?(char)
  end

  # A user name of letters, digits and ._%+- at csu.fullerton.edu, in any case.
  def self.email?(text)
    return false unless text.count("@") == 1 && text.downcase.end_with?(EMAIL_DOMAIN)

    user = text[0...-EMAIL_DOMAIN.length]
    !user.empty? && user.chars.all? { |c| alphanumeric?(c) || EMAIL_SYMBOLS.include?(c) }
  end

  # @ then 1 to 39 letters, digits or hyphens, which is what GitHub allows.
  def self.github_user?(text)
    user = text[1..].to_s
    text.start_with?("@") && user.length.between?(1, GITHUB_USER_MAX) && hyphens_inside?(user) &&
      user.chars.all? { |c| alphanumeric?(c) || c == "-" }
  end

  # Hyphens may only appear one at a time between letters or digits.
  def self.hyphens_inside?(user)
    !user.start_with?("-") && !user.end_with?("-") && !user.include?("--")
  end
end

# Tests for AUTHORS.txt itself.

def test_authors_file_exists(_args, assert)
  assert.true! File.exist?(AuthorsFormat::PATH), "AUTHORS.txt is missing from the top of the repository"
end

def test_authors_file_is_not_empty(_args, assert)
  assert.false! AuthorsFormat.lines.empty?,
                "AUTHORS.txt is empty. Add your name, CSU email and GitHub user name"
end

def test_authors_file_has_exactly_three_lines(_args, assert)
  assert.equal! AuthorsFormat.lines.size, 3, "AUTHORS.txt must have three lines: name, email, @github-user"
end

def test_authors_first_line_is_a_first_and_last_name(_args, assert)
  assert.true! AuthorsFormat.name?(AuthorsFormat.lines[0].to_s),
               "Line 1 must be a full name (at least a first and last name)"
end

def test_authors_second_line_is_a_csu_email_address(_args, assert)
  assert.true! AuthorsFormat.email?(AuthorsFormat.lines[1].to_s),
               "Line 2 must be an email address in the @csu.fullerton.edu domain"
end

def test_authors_third_line_is_a_github_user_name_prefixed_with_at(_args, assert)
  assert.true! AuthorsFormat.github_user?(AuthorsFormat.lines[2].to_s),
               "Line 3 must be your GitHub user name prefixed with @"
end

def test_authors_file_does_not_contain_the_readme_example(_args, assert)
  assert.not_equal! AuthorsFormat.lines, AuthorsFormat::README_EXAMPLE,
                    "AUTHORS.txt still contains the example from the README"
end

# Tests for the format checks, so the tests above can be trusted.

def test_authors_format_accepts_names(_args, assert)
  ["Tuffy Titan", "Tuffy Q. Titan", "Tuffy Quincy Titan", "Tuffy Titan-Smith",
   "Tuffy de la Cruz", "Tuffy O'Brien", "Tuffy O’Brien", "José Núñez"].each do |name|
    assert.true! AuthorsFormat.name?(name), "#{name.inspect} should be accepted"
  end
end

def test_authors_format_rejects_names(_args, assert)
  ["", "Tuffy", "Tuffy ", " Tuffy Titan", "Tuffy Titan2", "Tuffy_Titan", "-Tuffy Titan",
   "Tuffy\tTitan", "tuffy@csu.fullerton.edu"].each do |name|
    assert.false! AuthorsFormat.name?(name), "#{name.inspect} should be rejected"
  end
end

def test_authors_format_accepts_emails(_args, assert)
  ["tuffy@csu.fullerton.edu", "tuffy.titan@csu.fullerton.edu", "t+cs386@csu.fullerton.edu",
   "Tuffy@CSU.Fullerton.edu"].each do |email|
    assert.true! AuthorsFormat.email?(email), "#{email.inspect} should be accepted"
  end
end

def test_authors_format_rejects_emails(_args, assert)
  ["", "tuffy", "tuffy@fullerton.edu", "tuffy@gmail.com", "tuffy@csu.fullerton.edu.evil.com",
   "tuffy@mail.csu.fullerton.edu", "@csu.fullerton.edu", "a b@csu.fullerton.edu"].each do |email|
    assert.false! AuthorsFormat.email?(email), "#{email.inspect} should be rejected"
  end
end

def test_authors_format_accepts_github_user_names(_args, assert)
  ["@tuffytitan", "@tuffy-titan", "@t", "@Tuffy123", "@#{"a" * 39}"].each do |user|
    assert.true! AuthorsFormat.github_user?(user), "#{user.inspect} should be accepted"
  end
end

def test_authors_format_rejects_github_user_names(_args, assert)
  ["", "@", "tuffytitan", "@-tuffy", "@tuffy-", "@tuffy--titan", "@tuffy titan",
   "@tuffy_titan", "@#{"a" * 40}"].each do |user|
    assert.false! AuthorsFormat.github_user?(user), "#{user.inspect} should be rejected"
  end
end
