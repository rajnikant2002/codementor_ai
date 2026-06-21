import 'package:flutter/material.dart';

enum ToolFieldType { text, multiline, choice }

class ToolField {
  final String key;
  final String label;
  final String hint;
  final ToolFieldType type;
  final List<String> options;
  final int maxLines;

  const ToolField({
    required this.key,
    required this.label,
    required this.hint,
    this.type = ToolFieldType.text,
    this.options = const [],
    this.maxLines = 1,
  });
}

enum CareerTool {
  codeReview,
  atsResumeScore,
  resumeBuilder,
  projectGenerator,
  interviewQuestions,
  learningRoadmap,
  careerGuidance,
}

extension CareerToolX on CareerTool {
  String get title => switch (this) {
        CareerTool.codeReview => 'Code Review',
        CareerTool.atsResumeScore => 'ATS Resume Score',
        CareerTool.resumeBuilder => 'AI Resume Builder',
        CareerTool.projectGenerator => 'Project Ideas',
        CareerTool.interviewQuestions => 'Interview Questions',
        CareerTool.learningRoadmap => 'Learning Roadmap',
        CareerTool.careerGuidance => 'Career Guidance',
      };

  String get subtitle => switch (this) {
        CareerTool.codeReview => 'Analyze bugs, complexity, and fixes.',
        CareerTool.atsResumeScore => 'Check how well your resume matches ATS filters.',
        CareerTool.resumeBuilder => 'Turn rough notes into a polished resume.',
        CareerTool.projectGenerator => 'Generate project ideas from your skills.',
        CareerTool.interviewQuestions => 'Get role-specific interview practice questions.',
        CareerTool.learningRoadmap => 'Plan the skills to learn week by week.',
        CareerTool.careerGuidance => 'Get focused guidance on your next move.',
      };

  String get promptLabel => switch (this) {
        CareerTool.codeReview => 'Review Code',
        CareerTool.atsResumeScore => 'Score Resume',
        CareerTool.resumeBuilder => 'Build Resume',
        CareerTool.projectGenerator => 'Generate Ideas',
        CareerTool.interviewQuestions => 'Get Questions',
        CareerTool.learningRoadmap => 'Create Roadmap',
        CareerTool.careerGuidance => 'Get Guidance',
      };

  IconData get icon => switch (this) {
        CareerTool.codeReview => Icons.code,
        CareerTool.atsResumeScore => Icons.description_outlined,
        CareerTool.resumeBuilder => Icons.badge_outlined,
        CareerTool.projectGenerator => Icons.lightbulb_outline,
        CareerTool.interviewQuestions => Icons.quiz_outlined,
        CareerTool.learningRoadmap => Icons.route_outlined,
        CareerTool.careerGuidance => Icons.tips_and_updates_outlined,
      };

  List<ToolField> get fields => switch (this) {
        CareerTool.codeReview => const [
            ToolField(
              key: 'language',
              label: 'Programming language',
              hint: 'Choose the syntax you want reviewed',
              type: ToolFieldType.choice,
              options: ['C++', 'Java', 'Python', 'JavaScript'],
            ),
            ToolField(
              key: 'code',
              label: 'Code',
              hint: 'Paste the code you want reviewed',
              type: ToolFieldType.multiline,
              maxLines: 12,
            ),
          ],
        CareerTool.atsResumeScore => const [
            ToolField(
              key: 'resume',
              label: 'Resume text',
              hint: 'Paste your resume exactly as you want it scored',
              type: ToolFieldType.multiline,
              maxLines: 14,
            ),
          ],
        CareerTool.resumeBuilder => const [
            ToolField(
              key: 'name',
              label: 'Name',
              hint: 'Full name',
            ),
            ToolField(
              key: 'email',
              label: 'Email',
              hint: 'Email address',
            ),
            ToolField(
              key: 'skills',
              label: 'Skills',
              hint: 'Flutter, Firebase, Dart, API integration',
              type: ToolFieldType.multiline,
              maxLines: 3,
            ),
            ToolField(
              key: 'projects',
              label: 'Projects',
              hint: 'Key projects, impact, links, or bullet ideas',
              type: ToolFieldType.multiline,
              maxLines: 4,
            ),
            ToolField(
              key: 'education',
              label: 'Education',
              hint: 'Degree, institution, year',
              type: ToolFieldType.multiline,
              maxLines: 3,
            ),
            ToolField(
              key: 'experience',
              label: 'Experience',
              hint: 'Internships, jobs, freelance work',
              type: ToolFieldType.multiline,
              maxLines: 4,
            ),
          ],
        CareerTool.projectGenerator => const [
            ToolField(
              key: 'skills',
              label: 'Skills',
              hint: 'Flutter Firebase Gemini UI/UX',
              type: ToolFieldType.multiline,
              maxLines: 3,
            ),
          ],
        CareerTool.interviewQuestions => const [
            ToolField(
              key: 'role',
              label: 'Role',
              hint: 'Flutter Developer, Backend Intern, etc.',
            ),
          ],
        CareerTool.learningRoadmap => const [
            ToolField(
              key: 'goal',
              label: 'Goal',
              hint: 'Become a Flutter developer, learn system design, etc.',
              type: ToolFieldType.multiline,
              maxLines: 3,
            ),
          ],
        CareerTool.careerGuidance => const [
            ToolField(
              key: 'background',
              label: 'Background',
              hint: 'Current role, education, or experience',
              type: ToolFieldType.multiline,
              maxLines: 3,
            ),
            ToolField(
              key: 'goal',
              label: 'Target',
              hint: 'What you want to achieve next',
              type: ToolFieldType.multiline,
              maxLines: 3,
            ),
          ],
      };

  List<String> get expectedSections => switch (this) {
        CareerTool.codeReview => const ['Bugs', 'Complexity', 'Improvements', 'Fixed Code'],
        CareerTool.atsResumeScore => const ['ATS Score', 'Strengths', 'Weaknesses', 'Suggestions'],
        CareerTool.resumeBuilder => const [
            'Header',
            'Professional Summary',
            'Skills',
            'Projects',
            'Education',
            'Experience',
          ],
        CareerTool.projectGenerator => const ['Project Idea', 'Features', 'Tech Stack'],
        CareerTool.interviewQuestions => const ['Questions'],
        CareerTool.learningRoadmap => const ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Next Steps'],
        CareerTool.careerGuidance => const ['Snapshot', 'Strengths', 'Gaps', 'Action Plan', '30-Day Plan'],
      };

  String buildPrompt(Map<String, String> inputs) {
    switch (this) {
      case CareerTool.codeReview:
        final language = inputs['language']?.trim() ?? 'the selected language';
        final code = inputs['code']?.trim() ?? '';
        return '''
You are an expert software engineer. Review the following $language code.

Return exactly these headings:
Bugs
Complexity
Improvements
Fixed Code

Rules:
- Be specific and practical.
- Make the complexity explanation clear.
- For Fixed Code, provide only the corrected code.
- Keep the answer concise but useful.

Code:
```$language
$code
```
''';
      case CareerTool.atsResumeScore:
        final resume = inputs['resume']?.trim() ?? '';
        return '''
You are an ATS resume expert.

Return exactly these headings:
ATS Score
Strengths
Weaknesses
Suggestions

Rules:
- Score the resume out of 100.
- Use short bullets where helpful.
- Mention missing projects, measurable achievements, and keyword gaps when relevant.

Resume:
$resume
''';
      case CareerTool.resumeBuilder:
        return '''
You are a professional resume writer.

Create a polished resume using exactly these headings:
Header
Professional Summary
Skills
Projects
Education
Experience

Rules:
- Write in a clean ATS-friendly style.
- Use bullet points where appropriate.
- Make the result professional and ready to paste into a resume template.

Name: ${inputs['name'] ?? ''}
Email: ${inputs['email'] ?? ''}
Skills: ${inputs['skills'] ?? ''}
Projects: ${inputs['projects'] ?? ''}
Education: ${inputs['education'] ?? ''}
Experience: ${inputs['experience'] ?? ''}
''';
      case CareerTool.projectGenerator:
        return '''
You are an expert startup and product ideation assistant.

Return exactly these headings:
Project Idea
Features
Tech Stack

Rules:
- Suggest one strong, hackathon-friendly project idea.
- Include practical, buildable features.
- Keep the tech stack concise.

Skills:
${inputs['skills'] ?? ''}
''';
      case CareerTool.interviewQuestions:
        return '''
You are an interview coach.

Return exactly this heading:
Questions

Rules:
- Generate 5 interview questions.
- Make them relevant to the role.
- Mix conceptual and practical questions.

Role: ${inputs['role'] ?? ''}
''';
      case CareerTool.learningRoadmap:
        return '''
You are a learning mentor.

Return exactly these headings:
Week 1
Week 2
Week 3
Week 4
Next Steps

Rules:
- Make the roadmap simple and realistic.
- Focus on the fastest path to the goal.

Goal:
${inputs['goal'] ?? ''}
''';
      case CareerTool.careerGuidance:
        return '''
You are a career advisor.

Return exactly these headings:
Snapshot
Strengths
Gaps
Action Plan
30-Day Plan

Rules:
- Give direct, helpful career advice.
- Include practical next actions.

Background:
${inputs['background'] ?? ''}

Target:
${inputs['goal'] ?? ''}
''';
    }
  }
}
