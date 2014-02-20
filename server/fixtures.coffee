if Questions.find().count() is 0

  Questions.insert
    qid: 1
    question: "Please tell us your age"
    answers: [
      answer: "< 25"
      point: 10
    ,
      answer: "25-39"
      point: 6
    ,
      answer: "39-51"
      point: 4
    ,
      answer: "51-60"
      point: 2
    ,
      answer: "> 60"
      point: 0
    ]

  Questions.insert
    qid: 2
    question: "How would you describe your investment experience"
    answers: [
      answer: "Novice"
      point: 2
    ,
      answer: "Average"
      point: 4
    ,
      answer: "Extensive"
      point: 6
    ]

  Questions.insert
    qid: 3
    question: "What is your investment goal?"
    answers: [
      answer: "Retirement"
      point: 6
    ,
      answer: "College"
      point: 4
    ,
      answer: "House"
      point: 2
    ,
      answer: "Rainy Day"
      point: 0
    ]

  Questions.insert
    qid: 4
    question: "In 2008 the S&P 500 declined more than 38%, were you more inclined to ..."
    answers: [
      answer: "Sell"
      point: 0
    ,
      answer: "Buy"
      point: 6
    ,
      answer: "Do Nothing"
      point: 4
    ]

  Questions.insert
    qid: 5
    question: "Please tell us about your after tax income"
    answers: [
      answer: "< 15,000"
      point: 0
    ,
      answer: "15,000 - 24,999"
      point: 1
    ,
      answer: "25,000 - 49,999"
      point: 2
    ,
      answer: "50,000 - 99,999"
      point: 3
    ,
      answer: "100,000 - 149,999"
      point: 4
    ,
      answer: "150,000+"
      point: 4
    ]

  Questions.insert
    qid: 6
    question: "And your cash and liquid assets"
    answers: [
      answer: "< 25,000"
      point: 1
    ,
      answer: "25,000 - 49,999"
      point: 2
    ,
      answer: "50,000 - 99,999"
      point: 3
    ,
      answer: "100,000 - 249,999"
      point: 5
    ,
      answer: "250,000+"
      point: 8
    ]

  
    