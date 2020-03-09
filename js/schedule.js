// Schedule data
schedule = {
   "rooms": [
      "A1",
      "A2"
   ],
   "lectures": [
      {
         "name": "Test",
         "description": "Very long text description that accurately describes the lecture. Lorem ispum dolor sit amet, consectetur adipiscing elit ad ad dolor sit amet am I am I am I am I am I am I am I am I am I am I am I is the first am I am I am I am I am.",
         "timestampFrom": 1583747073400,
         "timestampTo": 1583747075200,
         "room": "A1"
      },
      {
         "name": "Test2",
         "description": "Very long text description that accurately describes the lecture. This is even better than the previous one.",
         "timestampFrom": 1583747073400,
         "timestampTo": 1583747077000,
         "room": "A2"
      }
   ]
}

/// Load upcoming lectures and display them at /index.html
function updateNextLectures() {
   let now = Date.now();
   let lectures_now = schedule.lectures.filter(lecture => lecture.timestampFrom < now && lecture.timestampTo > now);
   let lectures_upcoming = schedule.lectures.filter(lecture => lecture.timestampFrom > now);
}
