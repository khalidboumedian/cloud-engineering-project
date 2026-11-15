
async function loadMatches() {
    const statusElement = document.getElementById("data-status");
    const matchesContainer = document.getElementById("matches-container");

    try {
        statusElement.textContent = "Loading football data...";

        // 1. Request processed football data through CloudFront
        const response = await fetch("/processed/matches.json");

        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }

        const data = await response.json();

        // 2. Keep only completed matches
        const finishedMatches = data.matches.filter(
            match => match.status === "FINISHED"
        );

        // 3. Calculate total goals
        const totalGoals = finishedMatches.reduce(
            (total, match) =>
                total + match.home_score + match.away_score,
            0
        );

        // 4. Update dashboard statistics
        document.getElementById("total-matches").textContent =
            data.total_matches;

        document.getElementById("total-goals").textContent =
            totalGoals;

        document.getElementById("finished-matches").textContent =
            finishedMatches.length;

        statusElement.textContent =
            `${data.competition} | Season ${data.season}`;

        // 5. Display the latest 10 completed matches
        matchesContainer.innerHTML = "";

        const latestMatches = [...finishedMatches]
            .sort((a, b) => new Date(b.date) - new Date(a.date))
            .slice(0, 10);

        if (latestMatches.length === 0) {
            matchesContainer.innerHTML =
                '<p class="empty-message">No completed matches available.</p>';
            return;
        }

        latestMatches.forEach(match => {
            const matchCard = document.createElement("div");
            matchCard.className = "match-card";

            const homeTeam = document.createElement("div");
            homeTeam.className = "match-team";
            homeTeam.textContent = match.home_team;

            const score = document.createElement("div");
            score.className = "match-score";
            score.textContent =
                `${match.home_score} - ${match.away_score}`;

            const awayTeam = document.createElement("div");
            awayTeam.className = "match-team";
            awayTeam.textContent = match.away_team;

            const matchDay = document.createElement("div");
            matchDay.className = "match-day";
            matchDay.textContent = `Matchday ${match.matchday}`;

            matchCard.append(
                homeTeam,
                score,
                awayTeam,
                matchDay
            );

            matchesContainer.appendChild(matchCard);
        });

        console.log("Football data loaded successfully.");

    } catch (error) {
        console.error("Error loading football data:", error);

        statusElement.textContent = "Unable to load football data.";

        matchesContainer.innerHTML =
            '<p class="error-message">Could not load match results. Please try again later.</p>';
    }
}

// 6. Start loading data when the page is opened
loadMatches();
