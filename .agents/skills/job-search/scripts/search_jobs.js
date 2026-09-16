import { $ } from "bun";

const BLOCKLIST = new Set([
  "hire feed",
  "hired",
  "quick hire staffing",
  "bjak",
  "micro1",
  "second talent",
  "crossing hurdles"
]);

const KEYWORDS = [
  "golang",
  "backend engineer",
  "fullstack engineer",
  "devops",
  "ai engineer"
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
function matchesProfile(title, company, description) {
  const companyLower = company.toLowerCase();
  if (BLOCKLIST.has(companyLower)) {
    console.log(`[SKIP] Blocklisted company: ${company}`);
    return { matches: false, reason: "Company is blocklisted" };
  }

  // Exclude non-engineering/non-relevant roles (QA, Product Owner, Project Manager, etc.)
  const titleLower = title.toLowerCase();
  const excludeTitlePatterns = [
    /\bqa\b/,
    /\bquality\s+assurance\b/,
    /\btesting\b/,
    /\btest\s+engineer\b/,
    /\bproduct\s+owner\b/,
    /\bproduct\s+manager\b/,
    /\bproject\s+manager\b/,
    /\bscrum\s+master\b/,
    /\bengagement\s+manager\b/,
    /\bdelivery\s+manager\b/,
    /\bsales\b/,
    /\brecruiter\b/,
    /\bhris\b/,
    /\baccount\s+manager\b/,
    /\bsupport\s+engineer\b/,
    /\boperations\s+manager\b/,
    /\bprocess\s+engineer\b/,
    /\binjection\s+molding\b/,
    /\benablement\s+manager\b/,
    /\bhardware\b/
  ];
  const isExcludedTitle = excludeTitlePatterns.some(pattern => pattern.test(titleLower));
  if (isExcludedTitle) {
    console.log(`[SKIP] Non-engineering or non-relevant role: ${title}`);
    return { matches: false, reason: "Non-engineering/non-relevant role" };
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
  // (e.g. "Americas only", "reside in Europe")
  const isGeographicallyRestricted = geoRestrictions.some(r => {
    // If it contains Europe only, US only, Americas only, etc.
    const match = originalText.match(new RegExp(`(${r.source})\\s+(only|citizens?|residents?|based|reside|located)`, "i")) ||
                  originalText.match(new RegExp(`(must\\s+reside|must\\s+be\\s+based|only\\s+open\\s+to|citizens?\\s+of)\\s+in?\\s*(${r.source})`, "i"));
    if (match) {
      // Check if it also mentions Indonesia
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

  // Experience filter: 4+ years of experience
  // Look for patterns like "4+ years", "5+ years", "4 years", "senior", "lead"
  const experienceKeywords = ["4+", "5+", "6+", "7+", "8+", "9+", "4 years", "5 years", "6 years", "7 years", "8 years", "9 years", "senior", "lead", "sr."];
  const hasMinExperience = experienceKeywords.some(keyword => textToSearch.includes(keyword.toLowerCase()));
  if (!hasMinExperience) {
    // Check if the title itself has Senior/Lead/Sr/Staff/Principal
    const isSeniorTitle = /(senior|lead|sr|staff|principal|head|manager)/i.test(title);
    if (!isSeniorTitle) {
      console.log(`[SKIP] Title and description do not indicate 4+ years experience: ${title}`);
      return { matches: false, reason: "Does not require 4+ years or senior level" };
    }
  }

  // Tech stack matching
  // Must match Go (Golang), Node.js/TypeScript, general backend/fullstack, GCP/AWS/PostgreSQL, DevOps/infrastructure, AI Agent development/LLMs.
  // Exclude pure Java/Spring Boot, C#/.NET, PHP/Laravel (unless they also mention Go/Node or are open to other languages).
  
  // Good tech keywords (case-insensitive except Go)
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

  // Check case-sensitive Go (programming language)
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

  // Check for exclusive stacks like Java/C#/PHP
  const exclusiveRegex = /\b(java|spring boot|c#|\.net|php|laravel)\b/i;
  const matchesExclusive = exclusiveRegex.test(textToSearch);
  if (matchesExclusive) {
    // If it matches Java/C#/PHP, make sure it also mentions Go/Node or doesn't mandate it as the ONLY language.
    const hasGoOrNode = /\b(golang|go|typescript|node)/i.test(textToSearch);
    if (!hasGoOrNode) {
      console.log(`[SKIP] Pure Java/C#/PHP role: ${title}`);
      return { matches: false, reason: "Pure Java/C#/PHP stack" };
    }
  }

  // Visa & location checks (if remote/relocation mentioned, but since this is Indonesia local search, mostly fine)
  if (textToSearch.includes("no visa sponsorship") || textToSearch.includes("cannot sponsor")) {
    if (textToSearch.includes("must be currently based in") && !textToSearch.includes("indonesia")) {
      console.log(`[SKIP] Location/residency restrictions: ${title}`);
      return { matches: false, reason: "Residency restriction" };
    }
  }

  return { matches: true, matchedKeywords };
}

async function main() {
  const visitedCachePath = import.meta.dir + "/../cache/visited_jobs.json";
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

  const allJobIds = new Set();

  for (const keyword of KEYWORDS) {
    console.log(`\n=== Searching for "${keyword}" ===`);
    const searchRes = await callTool("linkedin.search_jobs", {
      keywords: keyword,
      location: "Indonesia",
      date_posted: "past_24_hours",
      job_type: "full_time",
      experience_level: "mid_senior",
      work_type: "on_site,remote,hybrid",
      max_pages: 2
    });

    if (searchRes && searchRes.job_ids) {
      console.log(`Found ${searchRes.job_ids.length} job IDs for "${keyword}"`);
      for (const id of searchRes.job_ids) {
        allJobIds.add(id);
      }
    }
    // Sleep a bit between search requests to avoid spamming the scaper
    await new Promise(r => setTimeout(r, 2000));
  }

  console.log(`\n=== Found ${allJobIds.size} unique job IDs in total ===`);

  // Filter out already visited job IDs
  const newJobIds = Array.from(allJobIds).filter(id => !visitedJobIds.has(id));
  console.log(`Filtered out ${allJobIds.size - newJobIds.length} already visited job(s). ${newJobIds.length} new job(s) to process.`);

  const matchedJobs = [];
  const batchSize = 4;

  for (let i = 0; i < newJobIds.length; i += batchSize) {
    const batch = newJobIds.slice(i, i + batchSize);
    console.log(`\n--- Fetching batch ${Math.floor(i / batchSize) + 1} of ${Math.ceil(newJobIds.length / batchSize)} (IDs: ${batch.join(", ")}) ---`);
    
    const results = await Promise.all(
      batch.map(async (jobId) => {
        try {
          const details = await callTool("linkedin.get_job_details", { job_id: jobId });
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

      console.log(`Checking: ${jobTitle} at ${companyName}`);
      const matchRes = matchesProfile(jobTitle, companyName, postingText);
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

    // Sleep 2 seconds between batches to be friendly
    await new Promise(r => setTimeout(r, 2000));
  }

  console.log(`\n=== MATCHED ${matchedJobs.length} JOBS ===`);
  
  // Helper to get clean summary of job description
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

  // Format output as markdown
  let md = `# LinkedIn Job Search Results (Indonesia, Last 24 Hours, Full-time, 4+ Years Experience)\n\n`;
  if (matchedJobs.length === 0) {
    md += `No matching jobs found in the last 24 hours.\n`;
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
