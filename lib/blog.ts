export type Post = {
  slug: string;
  title: string;
  excerpt: string;
  category: string;
  date: string;
  readTime: string;
  content: string[];
};

export const posts: Post[] = [
  {
    slug: "why-most-ai-pilots-never-ship",
    title: "Why most AI pilots never make it to production",
    excerpt:
      "A demo that impresses a room and a system that survives real users are built by different processes entirely. Here's where the gap usually forms.",
    category: "AI Systems",
    date: "2026-08-12",
    readTime: "6 min read",
    content: [
      "Most AI pilots die quietly. They work well enough in a demo, get approved for a wider rollout, and then stall somewhere between 'this works on my test cases' and 'this is dependable enough to put in front of a customer.'",
      "The gap isn't usually the model. It's everything around it: no evaluation harness to catch quality drift, no fallback when the model is wrong with confidence, and no monitoring that tells you a regression happened before a customer does.",
      "Treating an AI feature like any other production system — with tests, observability, and a rollback path — is what separates a pilot from something you can actually ship.",
    ],
  },
  {
    slug: "architecture-decisions-that-are-expensive-to-reverse",
    title: "The architecture decisions that are expensive to reverse",
    excerpt:
      "Most technical decisions are reversible with a refactor. A handful aren't. Knowing which is which changes how carefully you should make them.",
    category: "Engineering",
    date: "2026-07-02",
    readTime: "5 min read",
    content: [
      "Most engineering decisions are one-way doors you can walk back through later — a naming convention, a component library, even a framework choice, given enough time.",
      "A smaller set of decisions are genuinely expensive to reverse: your data model's core entities, your multi-tenancy strategy, and your approach to authentication and authorization. Get these wrong and every feature built on top inherits the cost.",
      "The practical takeaway is not to slow everything down — it's to spend deliberate time on the small number of decisions that are actually hard to undo, and move fast on everything else.",
    ],
  },
  {
    slug: "what-an-8-hour-trial-actually-tests",
    title: "What an 8-hour trial actually tests",
    excerpt:
      "Eight hours isn't long enough to judge code quality alone. It's long enough to judge whether an engineer fits how your team actually works.",
    category: "Working With Us",
    date: "2026-06-18",
    readTime: "4 min read",
    content: [
      "Eight hours won't tell you whether an engineer can architect a system from scratch. It will tell you whether they can read an unfamiliar codebase, ask the right questions in a standup, and ship something small correctly on the first try.",
      "That's a more useful signal for most hiring decisions than a take-home test or a whiteboard interview, because it's closer to the actual job.",
      "We treat the trial as a two-way evaluation — you're assessing us, and we're confirming the scope and expectations are clear before either side commits to anything larger.",
    ],
  },
  {
    slug: "gdpr-for-teams-that-arent-in-the-eu",
    title: "GDPR for teams that aren't based in the EU",
    excerpt:
      "If any of your users are in the EU, GDPR applies regardless of where your company is headquartered. Here's what that means in practice.",
    category: "Security & Compliance",
    date: "2026-05-24",
    readTime: "7 min read",
    content: [
      "GDPR applies based on whose data you're processing, not where your company is incorporated. A US-headquartered SaaS company with European users is in scope, full stop.",
      "In practice, this means a data processing record, a lawful basis for each category of data you collect, and a real deletion path when a user asks for one — not just a privacy policy page.",
      "Building this into the architecture from the start is materially cheaper than retrofitting it after an audit or a user complaint.",
    ],
  },
];
