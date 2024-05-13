class Question {
  final int id;
  final String question;
  final List<String> options;
  final String answer;
  final String feedback;

  Question(
      {required this.id,
      required this.question,
      required this.options,
      required this.answer,
      required this.feedback});
}

final List<Question> questionsData = [
  Question(
      id: 1,
      question: "Who always drives his customers away?",
      options: ['A doctor', 'A teacher', 'A taxi-driver', 'Flight engineer'],
      answer: "A taxi-driver",
      feedback: "Taxi-driver: tài xế taxi: người lái xe chở khách"),
  Question(
      id: 2,
      question: "Why is the letter E so important?",
      options: [
        'Because it is in the alphabet',
        'Because it is common',
        'Because it is very popular',
        'Because it is the beginning of everything',
      ],
      answer: "Because it is the beginning of everything",
      feedback: "E: chữ cái đầu tiên của “everything"),
  Question(
      id: 3,
      question: "What is the longest word in the English language?",
      options: ["Litter", "Smiles", "Cry", "Mother"],
      answer: "Smiles",
      feedback: "Smiles: giữa chữ cái đầu và cuối của từ đó là “mile"),
  Question(
      id: 4,
      question: "Where can you always find money?",
      options: [
        'In the dictionary',
        'In the textbook',
        'In the manual',
        'In the secret',
      ],
      answer: "In the dictionary",
      feedback:
          "In the dictionary: ở trong từ điển, bạn sẽ luôn tìm thấy từ “money”"),
  Question(
      id: 5,
      question: "What is higher without a head than with a head?",
      options: [
        'A pillow',
        'A blanket',
        'A pen',
        'A car',
      ],
      answer: "A pillow",

      feedback:
          "A pillow: cái gối: sẽ cao hơn khi ta không nằm lên nó"),

];
