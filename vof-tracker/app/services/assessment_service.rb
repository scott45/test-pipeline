module AssessmentService
  extend self
  def get_assessment_json
    {
      "Learning Clinic" => [
        "Growth Mindset",
        "Seeks Feedback",
        "Programming Logic",
        "Version Control",
        "GIT",
        "Test-Driven Development",
        "Excellence",
        "Integrity",
        "Commitment",
        "Collaboration",
        "Openness To Feedback",
        "Progress Attempts"
      ],
      "Home Session 1" => [
        "Object Oriented Programming",
        "Writing Professionally",
        "Excellence",
        "Passion",
        "Integrity",
        "Commitment"
      ],
      "Home Session 2" => [
        "Writing Professionally",
        "HTTP & Web Services",
        "Excellence",
        "Passion",
        "Integrity",
        "Commitment"
      ],
      "Home Session 3" => [
        "Writing Professionally",
        "Front-End Development",
        "Excellence",
        "Passion",
        "Integrity",
        "Commitment"
      ],
      "Home Session 4" => [
        "Openness To Feedback",
        "Progress Attempts"
      ],
      "One Day Onsite" => [
        "Relationship Building",
        "Asks Questions",
        "Agile Methodology",
        "Excellence",
        "Passion",
        "Integrity",
        "Commitment",
        "Collaboration",
        "Openness To Feedback",
        "Progress Attempts"
      ],
      "Bootcamp" => [
        "Adaptability",
        "Motivation and Commitment",
        "Databases",
        "Excellence",
        "Passion",
        "Integrity",
        "Commitment",
        "Collaboration",
        "Openness To Feedback",
        "Progress Attempts"
      ],
      "Project Assessment" => [
        "Version Control",
        "Project Management",
        "Test-Driven Development",
        "Code Syntax Norms",
        "Github Repository",
        "Code Understanding"
      ]
    }
  end
end
