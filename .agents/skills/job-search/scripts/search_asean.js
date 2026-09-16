import { $ } from "bun";

const BLOCKLIST = new Set([
  "hire feed",
  "hired",
  "quick hire staffing",
  "quik hire staffing",
  "bjak",
  "micro1",
  "second talent",
  "crossing hurdles"
]);

const COUNTRIES = [
  "Singapore",
  "Malaysia",
  "Indonesia",
  "Thailand",
  "Vietnam",
  "Philippines"
];

const KEYWORDS = [
  "golang",
  "typescript",
  "devops",
  "ai engineer",
  "agentic"
];

// Helper to call mcporter tools
async function callTool(toolName, args) {
  const argsList = Object.entries(args).map(([k, v]) => `${k}=${v}`);
  try {
    console.log(`Running: mcporter call ${toolName} ${argsList.join(" ")}`);
    const output = await $`mcporter call ${toolName} ${argsList}`.text();
    return JSON.parse(output);
  } catch (e) {
    console.error(`Error running ${toolName}:`, e);
    return null;
  }
}

// Check if job matches the candidate's profile
function matchesProfile(title, company, description, location) {
  const companyLower = company.toLowerCase();
  if (BLOCKLIST.has(companyLower)) {
    console.log(`[SKIP] Blocklisted company: ${company}`);
    return { matches: false, reason: "Company is blocklisted" };
  }

  const textToSearch = `${title} ${description}`.toLowerCase();
  const originalText = `${title} ${description}`;

  // Geographic restrictions (e.g. Americas only, US only, Europe only)
  const geoRestrictions = [
    /\bamericas?\b/i,
    /\bus (only|citizen|resident)/i,
    /\bcanada\b/i,
    /\bemea\b/i,
    /\beurope\b/i,
    /\buk (only|citizen|resident)/i,
    /\bengland\b/i,
    /\bgermany\b/i,
    /\bunited kingdom\b/i,
    /\baustralia\b/i,
    /\bnew zealand\b/i
  ];
  
  // If the job title/desc mentions these geographic regions, check if it's restricted to them
  const isGeographicallyRestricted = geoRestrictions.some(r => {
    const match = originalText.match(new RegExp(`(${r.source})\\s+(only|citizens?|residents?|based|reside|located)`, "i")) ||
                  originalText.match(new RegExp(`(must\\s+reside|must\\s+be\\s+based|only\\s+open\\s+to|citizens?\\s+of)\\s+in?\\s*(${r.source})`, "i"));
    if (match) {
      if (!/indonesia/i.test(originalText)) {
        return true;
      }
    }
    return false;
  });

  if (isGeographicallyRestricted) {
    console.log(`[SKIP] Geographic restriction detected: ${title}`);
    return { matches: false, reason: "Geographic restriction" };
  }

  // Check Visa & Location requirements for locations outside Indonesia
  const isIndonesia = /indonesia/i.test(location) || /jakarta/i.test(location);
  if (!isIndonesia) {
    // Exclude explicit "no sponsorship"
    const noSponsorshipRegexes = [
      /no\s+visa\s+sponsorship/i,
      /cannot\s+sponsor/i,
      /unable\s+to\s+sponsor/i,
      /no\s+sponsorship\s+is\s+available/i,
      /will\s+not\s+sponsor/i,
      /does\s+not\s+offer\s+sponsorship/i,
      /not\s+offering\s+sponsorship/i,
      /sponsorship\s+is\s+not\s+offered/i,
      /sponsorship\s+is\s+not\s+available/i,
      /no\s+sponsorship\s+offered/i,
      /not\s+eligible\s+for\s+sponsorship/i,
      /cannot\s+provide\s+sponsorship/i
    ];
    if (noSponsorshipRegexes.some(r => r.test(textToSearch))) {
      console.log(`[SKIP] Excluded: No visa sponsorship: ${title} at ${company}`);
      return { matches: false, reason: "Explicitly states no visa sponsorship" };
    }

    // Exclude "local only" or "citizens/PRs only"
    const localOnlyRegexes = [
      /locals?\s+only/i,
      /citizens?\s+only/i,
      /prs?\s+only/i,
      /permanent\s+residents?\s+only/i,
      /citizens?\s+or\s+permanent\s+residents?/i,
      /must\s+be\s+a\s+citizen/i,
      /must\s+be\s+a\s+pr\b/i,
      /only\s+open\s+to\s+(citizens|prs|residents)/i,
      /must\s+possess\s+valid\s+work\s+authorization/i,
      /must\s+already\s+have\s+the\s+right\s+to\s+work/i,
      /no\s+relocation\s+assistance/i,
      /does\s+not\s+provide\s+relocation/i,
      /relocation\s+is\s+not\s+provided/i,
      /not\s+offering\s+relocation/i
    ];
    if (localOnlyRegexes.some(r => r.test(textToSearch))) {
      console.log(`[SKIP] Excluded: Requires local work authorization / no relocation: ${title} at ${company}`);
      return { matches: false, reason: "Requires existing local work authorization or no relocation support" };
    }

    // Exclude residency requirements (e.g. "must be currently based/residing in Singapore")
    const mustBeInCountryRegexes = [
      /must\s+be\s+(currently\s+)?(based|residing|living)\s+in/i,
      /currently\s+(based|residing|living)\s+in/i,
      /only\s+open\s+to\s+candidates\s+(currently\s+)?in/i
    ];
    if (mustBeInCountryRegexes.some(r => r.test(textToSearch))) {
      if (!/indonesia/i.test(textToSearch)) {
        console.log(`[SKIP] Excluded: Requires candidate to be based in specific location: ${title} at ${company}`);
        return { matches: false, reason: "Requires candidate to already be based in specific location" };
      }
    }
  }

  // Experience filter: 4+ years of experience
  const experienceKeywords = ["4+", "5+", "6+", "7+", "8+", "9+", "4 years", "5 years", "6 years", "7 years", "8 years", "9 years", "senior", "lead", "sr."];
  const hasMinExperience = experienceKeywords.some(keyword => textToSearch.includes(keyword.toLowerCase()));
  if (!hasMinExperience) {
    const isSeniorTitle = /(senior|lead|sr|staff|principal|head|manager)/i.test(title);
    if (!isSeniorTitle) {
      console.log(`[SKIP] Title and description do not indicate 4+ years experience: ${title}`);
      return { matches: false, reason: "Does not require 4+ years or senior level" };
    }
  }

  // Tech stack matching
  const goodKeywords = [
    "golang", "go lang", "go programming",
    "typescript", "node.js", "node js", "nodejs", "javascript",
    "docker", "kubernetes", "gcp", "google cloud", "aws", "amazon web services",
    "postgresql", "postgres", "agentic", "llm", "mcp", "ai engineer", "devops"
  ];
  
  const matchedKeywords = [];
  goodKeywords.forEach(kw => {
    const regex = new RegExp(kw, "i");
    if (regex.test(textToSearch)) {
      matchedKeywords.push(kw);
    }
  });

  const hasCaseSensitiveGo = /\bGo\b/.test(originalText);
  if (hasCaseSensitiveGo && !matchedKeywords.includes("golang") && !matchedKeywords.includes("go lang")) {
    const hasTechContext = /\b(software|developer|engineer|backend|api|systems|git|cloud|sql|database|programming)\b/i.test(textToSearch);
    if (hasTechContext) {
      matchedKeywords.push("Go (lang)");
    }
  }

  if (matchedKeywords.length === 0) {
    console.log(`[SKIP] Tech stack mismatch (no Go, TS/Node, DevOps, GCP/AWS, LLM): ${title}`);
    return { matches: false, reason: "Tech stack mismatch" };
  }

  const exclusiveRegex = /\b(java|spring boot|c#|\.net|php|laravel)\b/i;
  const matchesExclusive = exclusiveRegex.test(textToSearch);
  if (matchesExclusive) {
    const hasGoOrNode = /\b(golang|go|typescript|node)/i.test(textToSearch);
    if (!hasGoOrNode) {
      console.log(`[SKIP] Pure Java/C#/PHP role: ${title}`);
      return { matches: false, reason: "Pure Java/C#/PHP stack" };
    }
  }

  return { matches: true, matchedKeywords };
}

async function main() {
  const cachePath = import.meta.dir + "/../cache/job_details.json";
  const searchCachePath = import.meta.dir + "/../cache/search_results_today.json";
  const visitedCachePath = import.meta.dir + "/../cache/visited_jobs.json";

  // Load visited job IDs cache
  let visitedJobIds = new Set();
  try {
    const visitedContent = await Bun.file(visitedCachePath).text();
    const visitedList = JSON.parse(visitedContent);
    if (Array.isArray(visitedList)) {
      visitedJobIds = new Set(visitedList);
      console.log(`Loaded ${visitedJobIds.size} visited job IDs from cache.`);
    }
  } catch (e) {
    console.log("No existing visited jobs cache found. Starting fresh.");
  }
  // Load job details cache
  let cachedDetails = {};
  try {
    const fileContent = await Bun.file(cachePath).text();
    cachedDetails = JSON.parse(fileContent);
    console.log(`Loaded ${Object.keys(cachedDetails).length} cached job details.`);
  } catch (e) {
    console.log("No existing job details cache found, starting fresh.");
  }

  // Load search results cache for today
  let cachedSearchIds = [];
  let hasSearchCache = false;
  try {
    const fileContent = await Bun.file(searchCachePath).text();
    const searchCache = JSON.parse(fileContent);
    const today = new Date().toISOString().split("T")[0];
    if (searchCache.date === today && searchCache.jobIds) {
      cachedSearchIds = searchCache.jobIds;
      hasSearchCache = true;
      console.log(`Loaded ${cachedSearchIds.length} cached job IDs from today's search cache.`);
    }
  } catch (e) {
    // Ignore cache load failure
  }

  const allJobIds = new Set(cachedSearchIds);

  if (!hasSearchCache) {
    // Search each country for each keyword
    for (const country of COUNTRIES) {
      for (const keyword of KEYWORDS) {
        console.log(`\n=== Searching for "${keyword}" in "${country}" ===`);
        const searchRes = await callTool("linkedin.search_jobs", {
          keywords: keyword,
          location: country,
          date_posted: "past_24_hours",
          job_type: "full_time",
          experience_level: "associate,mid_senior",
          work_type: "on_site,remote,hybrid",
          max_pages: 1
        });

        if (searchRes && searchRes.job_ids) {
          console.log(`Found ${searchRes.job_ids.length} job IDs in ${country} for "${keyword}"`);
          for (const id of searchRes.job_ids) {
            allJobIds.add(id);
          }
        }
        // Sleep a bit to avoid rate limits
        await new Promise(r => setTimeout(r, 1500));
      }
    }

    // Save search results cache
    try {
      const today = new Date().toISOString().split("T")[0];
      await Bun.write(searchCachePath, JSON.stringify({
        date: today,
        jobIds: Array.from(allJobIds)
      }, null, 2));
      console.log(`Saved ${allJobIds.size} job IDs to search cache.`);
    } catch (e) {
      console.error("Failed saving search cache:", e);
    }
  }

  console.log(`\n=== Found ${allJobIds.size} unique job IDs in total ===`);

  // Filter out already visited job IDs
  const newJobIds = Array.from(allJobIds).filter(id => !visitedJobIds.has(id));
  console.log(`Filtered out ${allJobIds.size - newJobIds.length} already visited job(s). ${newJobIds.length} new job(s) to process.`);

  const matchedJobs = [];
  const batchSize = 4;

  for (let i = 0; i < newJobIds.length; i += batchSize) {
    const batch = newJobIds.slice(i, i + batchSize);
    console.log(`\n--- Processing batch ${Math.floor(i / batchSize) + 1} of ${Math.ceil(newJobIds.length / batchSize)} (IDs: ${batch.join(", ")}) ---`);
    
    // Collect which details need to be fetched fresh vs from cache
    const results = await Promise.all(
      batch.map(async (jobId) => {
        if (cachedDetails[jobId]) {
          console.log(`Using cached details for job ID: ${jobId}`);
          return { jobId, details: cachedDetails[jobId] };
        }
        
        try {
          const details = await callTool("linkedin.get_job_details", { job_id: jobId });
          if (details && details.sections && details.sections.job_posting) {
            cachedDetails[jobId] = details;
            // Write cache incrementally to avoid data loss on interrupts
            await Bun.write(cachePath, JSON.stringify(cachedDetails, null, 2));
          }
          return { jobId, details };
        } catch (e) {
          console.error(`Failed fetching details for ${jobId}:`, e);
          return { jobId, details: null };
        }
      })
    );

    for (const { jobId, details } of results) {
      if (!details || !details.sections || !details.sections.job_posting) {
        console.log(`Failed to fetch details for ${jobId}`);
        continue;
      }
      const postingText = details.sections.job_posting;
      if (postingText.includes("Job id provided may not be valid") || postingText.includes("Unable to load the page")) {
        console.log(`Failed to fetch details for ${jobId} (Unable to load the page)`);
        continue;
      }

      const lines = postingText.split("\n").map(l => l.trim()).filter(Boolean);
      const companyName = lines[0] || "Unknown Company";
      const jobTitle = lines[1] || "Unknown Title";
      const locationLine = lines[2] || "Unknown Location";

      console.log(`Checking: ${jobTitle} at ${companyName} (${locationLine})`);
      const matchRes = matchesProfile(jobTitle, companyName, postingText, locationLine);
      if (matchRes.matches) {
        matchedJobs.push({
          id: jobId,
          title: jobTitle,
          company: companyName,
          location: locationLine,
          url: details.url,
          description: postingText,
          matchedKeywords: matchRes.matchedKeywords
        });
        console.log(`[MATCH] ${jobTitle} at ${companyName} (Matched stack: ${matchRes.matchedKeywords.join(", ")})`);
      }
    }

    // Only sleep if we fetched something from the network
    const fetchedFresh = batch.some(jobId => !cachedDetails[jobId]);
    if (fetchedFresh) {
      await new Promise(r => setTimeout(r, 1500));
    }
  }

  console.log(`\n=== MATCHED ${matchedJobs.length} JOBS ===`);
  
  function getCleanSummary(description) {
    let cleanDesc = description;
    const splitKeywords = [
      "about the job",
      "about the role",
      "job description",
      "responsibilities",
      "requirements"
    ];

    for (const sk of splitKeywords) {
      const idx = cleanDesc.toLowerCase().indexOf(sk);
      if (idx !== -1) {
        const candidate = cleanDesc.substring(idx);
        if (candidate.length > 200) {
          cleanDesc = candidate;
          break;
        }
      }
    }

    const lines = cleanDesc.split("\n").map(l => l.trim()).filter(Boolean);
    let summary = lines.slice(0, 12).join("\n");
    if (summary.length > 1000) {
      summary = summary.substring(0, 1000) + "...";
    }
    return summary;
  }

  let md = `# LinkedIn Job Search Results (ASEAN, Last 24 Hours, Full-time, 4+ Years Experience)\n\n`;
  md += `Search run at: ${new Date().toISOString()}\n\n`;
  if (matchedJobs.length === 0) {
    md += `No matching jobs found in the last 24 hours in the ASEAN region.\n`;
  } else {
    md += `| Job Title | Company | Location | Matched Tech | Link |\n`;
    md += `|---|---|---|---|---|\n`;
    for (const job of matchedJobs) {
      md += `| **${job.title}** | ${job.company} | ${job.location.split(" · ")[0]} | \`${job.matchedKeywords.join(", ")}\` | [View Job](${job.url}) |\n`;
    }
    md += `\n## Details\n\n`;
    for (const job of matchedJobs) {
      md += `### [${job.title} at ${job.company}](${job.url})\n`;
      md += `- **Location & Metadata:** ${job.location}\n`;
      md += `- **Job ID:** \`${job.id}\`\n`;
      md += `- **Matched Tech Keywords:** \`${job.matchedKeywords.join(", ")}\`\n\n`;
      md += `#### Description Excerpt:\n\`\`\`text\n`;
      md += `${getCleanSummary(job.description)}\n\`\`\`\n\n`;
      md += `---\n\n`;
    }
  }
  if (matchedJobs.length > 0) {
    for (const job of matchedJobs) {
      visitedJobIds.add(job.id);
    }
    try {
      await Bun.write(visitedCachePath, JSON.stringify(Array.from(visitedJobIds), null, 2));
      console.log(`Updated visited jobs cache with ${matchedJobs.length} new matched job(s).`);
    } catch (e) {
      console.error("Failed saving visited jobs cache:", e);
    }
  }

  await Bun.write(import.meta.dir + "/../job_search_results.md", md);
  console.log("Results written to skills/job-search/job_search_results.md");
}

main().catch(console.error);
