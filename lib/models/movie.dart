/// Represents a movie entity used across the app.
class Movie {
  final String title;

  /// Cloudinary Poster URL
  final String posterPath;

  /// Cloudinary Banner URL
  final String? bannerUrl;

  /// Cloudinary Movie Video URL
  final String? videoUrl;

  final String? genre;
  final double? rating;

  /// For "Continue Watching"
  final double? watchProgress;

  /// Example: "S1 · E04 · 15m left"
  final String? progressLabel;

  /// Movie description
  final String? description;

  /// Duration (e.g. 2H 45M)
  final String? duration;

  /// Release year
  final String? year;

  /// Genre tags
  final List<String>? tags;

  /// Cast members
  final List<Map<String, String>>? cast;

  /// Trailer URL
  final String? trailerUrl;

  /// Director
  final String? director;

  /// Firestore Flags
  final bool featured;
  final bool trending;
  final bool popular;
  final bool recommended;

  const Movie({
    required this.title,
    required this.posterPath,

    this.bannerUrl,
    this.videoUrl,

    this.genre,
    this.rating,

    this.watchProgress,
    this.progressLabel,

    this.description,
    this.duration,
    this.year,

    this.tags,
    this.cast,

    this.trailerUrl,
    this.director,

    this.featured = false,
    this.trending = false,
    this.popular = false,
    this.recommended = false,
  });
}

/// Sample movie data for the home screen sections.
class MovieData {
  // ── Trending Movies ──
  static const List<Movie> trending = [
    Movie(
      title: "Coolie",
      posterPath: "assets/trending assets/Rajinikanth.jpeg",
      genre: "Action",
      rating: 8.5,
      description:
          "Deva, a seemingly ordinary coolie at a railway station, harbors a dangerous past. When a ruthless crime syndicate threatens innocent lives, he rises from the shadows to wage a one-man war against corruption and injustice, revealing a deadly skill set no one expected.",
      duration: "2H 45M",
      year: "2025",
      tags: ["Action", "Thriller", "Crime"],
      director: "Lokesh Kanagaraj",
      trailerUrl: "https://www.youtube.com/watch?v=Wy6v0RSWKHE",
      cast: [
        {"name": "Rajinikanth", "role": "Deva"},
        {"name": "Shruti Haasan", "role": "Lead"},
        {"name": "Nagarjuna", "role": "Antagonist"},
        {"name": "Sathyaraj", "role": "Supporting"},
      ],
    ),
    Movie(
      title: "Master",
      posterPath:
          "assets/trending assets/Thalapathy-Vijay-s-Master-movie-second-Look-Poster-.webp",
      genre: "Action",
      rating: 8.7,
      description:
          "JD, an alcoholic professor, is transferred to a juvenile home where he clashes with Bhavani, a ruthless gangster who exploits the young inmates for criminal activities. A gripping battle of wits and strength ensues as JD fights to save the children from darkness.",
      duration: "2H 58M",
      year: "2021",
      tags: ["Action", "Thriller", "Drama"],
      director: "Lokesh Kanagaraj",
      trailerUrl: "https://www.youtube.com/watch?v=u3gH3s-T-8Y",
      cast: [
        {"name": "Thalapathy Vijay", "role": "JD"},
        {"name": "Vijay Sethupathi", "role": "Bhavani"},
        {"name": "Malavika Mohanan", "role": "Charulatha"},
        {"name": "Andrea Jeremiah", "role": "Deepa"},
      ],
    ),
    Movie(
      title: "LIK",
      posterPath: "assets/trending assets/maxresdefault.jpg",
      genre: "Comedy",
      rating: 7.8,
      description:
          "Set in the year 2040, Vibe Vassey challenges a futuristic matchmaking app called 'LIK' (Love Insurance Kompany) that uses advanced algorithms to insure and control human relationships. A hilarious sci-fi romantic comedy about love vs technology.",
      duration: "2H 20M",
      year: "2026",
      tags: ["Sci-Fi", "Romance", "Comedy"],
      director: "Vignesh Shivan",
      trailerUrl: "https://www.youtube.com/watch?v=J189u3T263M",
      cast: [
        {"name": "Pradeep Ranganathan", "role": "Vibe Vassey"},
        {"name": "Krithi Shetty", "role": "Lead"},
        {"name": "SJ Suryah", "role": "LIK Founder"},
        {"name": "Yogi Babu", "role": "Supporting"},
      ],
    ),
    Movie(
      title: "Karuppu",
      posterPath: "assets/trending assets/OIP.webp",
      genre: "Action",
      rating: 8.1,
      description:
          "A powerful tale of redemption and justice set in rural Tamil Nadu. Karuppu, a man of honor, fights against the oppressive forces threatening his village and loved ones. An action-packed drama with emotional depth and stunning visuals.",
      duration: "2H 35M",
      year: "2026",
      tags: ["Action", "Drama", "Mass"],
      director: "RJ Balaji",
      trailerUrl: "https://www.youtube.com/watch?v=Llss1aRo8tw",
      cast: [
        {"name": "Suriya", "role": "Karuppu"},
        {"name": "Trisha", "role": "Lead"},
        {"name": "RJ Balaji", "role": "Supporting"},
        {"name": "Indrans", "role": "Supporting"},
      ],
    ),
  ];

  // ── Continue Watching ──
  static const List<Movie> continueWatching = [
    Movie(
      title: "Coolie",
      posterPath: "assets/trending assets/Rajinikanth.jpeg",
      watchProgress: 0.65,
      progressLabel: "S1 · E04 · 15m left",
      description:
          "Deva, a seemingly ordinary coolie at a railway station, harbors a dangerous past. When a ruthless crime syndicate threatens innocent lives, he rises from the shadows to wage a one-man war against corruption and injustice.",
      duration: "2H 45M",
      year: "2025",
      genre: "Action",
      rating: 8.5,
      tags: ["Action", "Thriller", "Crime"],
      director: "Lokesh Kanagaraj",
      trailerUrl: "https://www.youtube.com/watch?v=Wy6v0RSWKHE",
      cast: [
        {"name": "Rajinikanth", "role": "Deva"},
        {"name": "Shruti Haasan", "role": "Lead"},
        {"name": "Nagarjuna", "role": "Antagonist"},
        {"name": "Sathyaraj", "role": "Supporting"},
      ],
    ),
    Movie(
      title: "Project Hail Mary",
      posterPath:
          "assets/popular assets/project-hail-mary-poster-2_rgb-scaled.jpg",
      watchProgress: 0.35,
      progressLabel: "01:42 · 42m left",
      description:
          "Ryland Grace, a lone astronaut on a desperate mission, must save humanity from an extinction-level threat. Stranded light-years from Earth with only his memories slowly returning, he discovers an unlikely ally in the most unexpected place.",
      duration: "2H 30M",
      year: "2026",
      genre: "Sci-Fi",
      rating: 8.8,
      tags: ["Sci-Fi", "Adventure", "Drama"],
      director: "Phil Lord & Christopher Miller",
      trailerUrl: "https://www.youtube.com/watch?v=m08TxIsFTRI",
      cast: [
        {"name": "Ryan Gosling", "role": "Ryland Grace"},
        {"name": "Sandra Bullock", "role": "Stratt"},
        {"name": "Barry Keoghan", "role": "Supporting"},
        {"name": "Cynthia Erivo", "role": "Supporting"},
      ],
    ),
    Movie(
      title: "The Hangover Part II",
      posterPath: "assets/recommend assets/OIP.webp",
      watchProgress: 0.80,
      progressLabel: "01:15 · 10m left",
      description:
          "Phil, Stu, Alan, and Doug travel to exotic Thailand for Stu's wedding. After an unforgettable bachelor party in Las Vegas, they wake up in Bangkok with no memory of the previous night, a missing friend, and chaos everywhere.",
      duration: "1H 42M",
      year: "2011",
      genre: "Comedy",
      rating: 7.8,
      tags: ["Comedy", "Adventure"],
      director: "Todd Phillips",
      trailerUrl: "https://www.youtube.com/watch?v=kY3otCC1S48",
      cast: [
        {"name": "Bradley Cooper", "role": "Phil"},
        {"name": "Ed Helms", "role": "Stu"},
        {"name": "Zach Galifianakis", "role": "Alan"},
        {"name": "Ken Jeong", "role": "Mr. Chow"},
      ],
    ),
  ];

  // ── Popular Movies ──
  static const List<Movie> popular = [
    Movie(
      title: "Spider-Man: No Way Home",
      posterPath: "assets/popular assets/OIP (1).webp",
      genre: "Action",
      rating: 8.3,
      description:
          "When Doctor Strange's spell goes wrong, Peter Parker's identity as Spider-Man is revealed to the entire world. With villains from alternate universes pouring in, Peter must team up with other Spider-Men to restore the multiverse and make an impossible sacrifice.",
      duration: "2H 28M",
      year: "2021",
      tags: ["Action", "Superhero", "Sci-Fi"],
      director: "Jon Watts",
      trailerUrl: "https://www.youtube.com/watch?v=JfVOs7y_q7U",
      cast: [
        {"name": "Tom Holland", "role": "Peter Parker"},
        {"name": "Zendaya", "role": "MJ"},
        {"name": "Benedict Cumberbatch", "role": "Dr. Strange"},
        {"name": "Alfred Molina", "role": "Doc Ock"},
      ],
    ),
    Movie(
      title: "The Sheep Detectives",
      posterPath: "assets/popular assets/OIP.webp",
      genre: "Comedy",
      rating: 7.5,
      description:
          "When their beloved shepherd George is found dead under mysterious circumstances, a flock of clever sheep decides to solve the murder themselves. Led by the wise Miss Maple, the sheep uncover a web of village secrets and suspects no one expected.",
      duration: "1H 50M",
      year: "2026",
      tags: ["Comedy", "Mystery", "Animation"],
      director: "Kyle Balda",
      trailerUrl: "https://www.youtube.com/watch?v=N4gKv5dMmhY",
      cast: [
        {"name": "Hugh Jackman", "role": "George Hardy"},
        {"name": "Emma Thompson", "role": "Supporting"},
        {"name": "Julia Louis-Dreyfus", "role": "Miss Maple (voice)"},
        {"name": "Bryan Cranston", "role": "Othello (voice)"},
      ],
    ),
    Movie(
      title: "Project Hail Mary",
      posterPath:
          "assets/popular assets/project-hail-mary-poster-2_rgb-scaled.jpg",
      genre: "Sci-Fi",
      rating: 8.8,
      description:
          "Ryland Grace, a lone astronaut on a desperate mission, must save humanity from an extinction-level threat. Stranded light-years from Earth with only his memories slowly returning, he discovers an unlikely ally in the most unexpected place.",
      duration: "2H 30M",
      year: "2026",
      tags: ["Sci-Fi", "Adventure", "Drama"],
      director: "Phil Lord & Christopher Miller",
      trailerUrl: "https://www.youtube.com/watch?v=m08TxIsFTRI",
      cast: [
        {"name": "Ryan Gosling", "role": "Ryland Grace"},
        {"name": "Sandra Bullock", "role": "Stratt"},
        {"name": "Barry Keoghan", "role": "Supporting"},
        {"name": "Cynthia Erivo", "role": "Supporting"},
      ],
    ),
    Movie(
      title: "Obsession",
      posterPath: "assets/popular assets/th.webp",
      genre: "Thriller",
      rating: 7.9,
      description:
          "A successful surgeon's carefully constructed life begins to unravel when he embarks on a dangerous affair with his son's new girlfriend. Secrets, lies, and obsession spiral into a dark thriller where desire and destruction collide.",
      duration: "1H 48M",
      year: "2023",
      tags: ["Thriller", "Drama", "Romance"],
      director: "Lisa Barros D'Sa",
      trailerUrl: "https://www.youtube.com/watch?v=5M906-P0u9k",
      cast: [
        {"name": "Richard Armitage", "role": "William"},
        {"name": "Charlie Murphy", "role": "Anna"},
        {"name": "Indira Varma", "role": "Ingrid"},
        {"name": "Rish Shah", "role": "Jay"},
      ],
    ),
  ];

  // ── Recommended For You ──
  static const List<Movie> recommended = [
    Movie(
      title: "Scream 7",
      posterPath: "assets/recommend assets/OIP (1).webp",
      genre: "Horror",
      rating: 7.6,
      description:
          "Sidney Prescott must confront the horrors of her past once more when a new Ghostface killer begins targeting her daughter. Returning to Woodsboro, she teams up with old allies to end the nightmare once and for all in this chilling new chapter.",
      duration: "2H 05M",
      year: "2026",
      tags: ["Horror", "Thriller", "Mystery"],
      director: "Kevin Williamson",
      trailerUrl: "https://www.youtube.com/watch?v=mSb6MeFp5cA",
      cast: [
        {"name": "Neve Campbell", "role": "Sidney Prescott"},
        {"name": "Courteney Cox", "role": "Gale Weathers"},
        {"name": "Isabel May", "role": "Supporting"},
        {"name": "McKenna Grace", "role": "Supporting"},
      ],
    ),
    Movie(
      title: "The Angry Birds Movie 2",
      posterPath: "assets/recommend assets/OIP (2).webp",
      genre: "Animation",
      rating: 7.2,
      description:
          "When a new threat emerges that puts both Bird and Pig Islands in danger, Red, Chuck, Bomb, and the pigs must forge an unlikely alliance. Together, they must hatch a plan to stop the villain before their homes are destroyed forever.",
      duration: "1H 36M",
      year: "2019",
      tags: ["Animation", "Comedy", "Family"],
      director: "Thurop Van Orman",
      trailerUrl: "https://www.youtube.com/watch?v=hU9p4t_T4Jk",
      cast: [
        {"name": "Jason Sudeikis", "role": "Red (voice)"},
        {"name": "Josh Gad", "role": "Chuck (voice)"},
        {"name": "Leslie Jones", "role": "Zeta (voice)"},
        {"name": "Bill Hader", "role": "Leonard (voice)"},
      ],
    ),
    Movie(
      title: "The Hangover Part II",
      posterPath: "assets/recommend assets/OIP.webp",
      genre: "Comedy",
      rating: 7.8,
      description:
          "Phil, Stu, Alan, and Doug travel to exotic Thailand for Stu's wedding. After an unforgettable bachelor party in Las Vegas, they wake up in Bangkok with no memory of the previous night, a missing friend, and chaos everywhere.",
      duration: "1H 42M",
      year: "2011",
      tags: ["Comedy", "Adventure"],
      director: "Todd Phillips",
      trailerUrl: "https://www.youtube.com/watch?v=kY3otCC1S48",
      cast: [
        {"name": "Bradley Cooper", "role": "Phil"},
        {"name": "Ed Helms", "role": "Stu"},
        {"name": "Zach Galifianakis", "role": "Alan"},
        {"name": "Ken Jeong", "role": "Mr. Chow"},
      ],
    ),
    Movie(
      title: "Coolie",
      posterPath: "assets/trending assets/Rajinikanth.jpeg",
      genre: "Action",
      rating: 8.5,
      description:
          "Deva, a seemingly ordinary coolie at a railway station, harbors a dangerous past. When a ruthless crime syndicate threatens innocent lives, he rises from the shadows to wage a one-man war against corruption and injustice.",
      duration: "2H 45M",
      year: "2025",
      tags: ["Action", "Thriller", "Crime"],
      director: "Lokesh Kanagaraj",
      trailerUrl: "https://www.youtube.com/watch?v=Wy6v0RSWKHE",
      cast: [
        {"name": "Rajinikanth", "role": "Deva"},
        {"name": "Shruti Haasan", "role": "Lead"},
        {"name": "Nagarjuna", "role": "Antagonist"},
        {"name": "Sathyaraj", "role": "Supporting"},
      ],
    ),
  ];
}
