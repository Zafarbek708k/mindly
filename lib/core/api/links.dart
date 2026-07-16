abstract class Links {
  static const String baseUrl = 'https://api.mindly.app/';
}

abstract class Endpoints {
  static const mockApi = 'https://65cafef6efec34d9ed868402.mockapi.io/mindly';

  static const refreshToken = 'v1/auth/refresh';
  static const Set<String> noAuthPaths = {refreshToken};
}


final mockApiMindlyResponse = [
  {
    "quiz_id": "math-basics",
    "title": "Simple Math Quiz",
    "duration_minutes": 20,
    "questions": [
      {"id": "q1", "text": "What is 7 + 8?", "options": ["13", "15", "16", "14"], "correct_index": 1},
      {"id": "q2", "text": "What is 12 Ã— 12?", "options": ["124", "142", "144", "148"], "correct_index": 2},
      {"id": "q3", "text": "What is 81 Ã· 9?", "options": ["8", "9", "7", "6"], "correct_index": 1},
      {"id": "q4", "text": "What is 25% of 200?", "options": ["25", "75", "100", "50"], "correct_index": 3},
      {
        "id": "q5",
        "text": "What is 15 âˆ’ 27?",
        "options": ["-12", "12", "-13", "All answers are incorrect"],
        "correct_index": 0
      },
      {"id": "q6", "text": "What is the square root of 169?", "options": ["11", "12", "13", "14"], "correct_index": 2},
      {"id": "q7", "text": "What is 3Â² + 4Â²?", "options": ["24", "25", "49", "12"], "correct_index": 1},
      {"id": "q8", "text": "If x + 5 = 12, what is x?", "options": ["17", "6", "8", "7"], "correct_index": 3},
      {
        "id": "q9",
        "text": "What is 1000 Ã· 8?",
        "options": ["120", "135", "115", "All answers are incorrect"],
        "correct_index": 3
      },
      {"id": "q10", "text": "What is 6 Ã— 7 âˆ’ 2?", "options": ["40", "44", "42", "36"], "correct_index": 0}
    ]
  }
];