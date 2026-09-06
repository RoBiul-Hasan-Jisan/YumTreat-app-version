export type Service = {
  slug: string;
  name: string;
  short: string;
  description: string;
  bullets: string[];
};

export const services: Service[] = [
  {
    slug: "advanced-web-applications",
    name: "Advanced Web Applications",
    short: "High-performance web platforms built for scale, not demos.",
    description:
      "We design and engineer web applications that hold up under real production load — complex dashboards, multi-tenant SaaS, and internal tools that hundreds of people rely on daily. Architecture decisions are made up front, not retrofitted after launch.",
    bullets: [
      "React, Next.js, and Vue front ends with strict performance budgets",
      "Multi-tenant architecture and role-based access control",
      "API-first backends built for horizontal scale",
    ],
  },
  {
    slug: "white-label-services",
    name: "White Label Services",
    short: "A senior engineering team operating fully under your brand.",
    description:
      "Agencies and consultancies use our team as their delivery arm — we build, you present. Clients never see our name, our invoices, or our Slack. NDAs are standard, not a favor.",
    bullets: [
      "Zero-visibility delivery — no branding, no attribution",
      "You own the client relationship end to end",
      "Scales up or down with your pipeline",
    ],
  },
  {
    slug: "ai-systems-and-automations",
    name: "AI Systems and Automations",
    short: "Production AI — not prototypes that stall after the demo.",
    description:
      "We build the systems around the model: retrieval pipelines, agent workflows, evaluation harnesses, and the plumbing that turns an LLM call into a dependable feature. Model-agnostic by default, so you're never locked to one vendor's roadmap.",
    bullets: [
      "RAG pipelines, agents, and internal automation tooling",
      "Evaluation and monitoring so quality doesn't drift silently",
      "Works across OpenAI, Anthropic, and open-weight models",
    ],
  },
  {
    slug: "security-and-compliance",
    name: "Security & Compliance",
    short: "Software that survives an audit, not just a launch.",
    description:
      "We build to ISO 27001 and GDPR requirements from day one — access controls, encryption at rest and in transit, and audit logging are part of the architecture, not a checklist added before a compliance review.",
    bullets: [
      "GDPR-aligned data handling and retention design",
      "Penetration-test-ready architecture reviews",
      "SOC 2 and ISO 27001 readiness support",
    ],
  },
  {
    slug: "custom-software-development",
    name: "Custom Software Development",
    short: "Purpose-built systems where off-the-shelf software falls short.",
    description:
      "Some workflows are specific enough that no SaaS product will fit them cleanly. We build custom platforms — internal tools, operational systems, and customer-facing products — designed around how your business actually runs.",
    bullets: [
      "Discovery and technical scoping before a line of code is written",
      "Modular architecture built for the next three years, not just launch",
      "Full ownership of source code and infrastructure handed over to you",
    ],
  },
  {
    slug: "cloud-infrastructure",
    name: "Cloud Infrastructure",
    short: "Infrastructure that scales predictably and fails safely.",
    description:
      "We design and manage cloud environments on AWS, GCP, and Azure — infrastructure as code, automated deployments, and monitoring that tells you about a problem before your customers do.",
    bullets: [
      "Infrastructure as code (Terraform, Pulumi)",
      "CI/CD pipelines and zero-downtime deployments",
      "Cost optimization and autoscaling design",
    ],
  },
  {
    slug: "resource-augmentation",
    name: "Resource Augmentation",
    short: "Senior engineers embedded directly in your existing team.",
    description:
      "When you need capacity, not a new vendor relationship, we place senior engineers inside your workflow — your standups, your repos, your tools — under your technical leadership.",
    bullets: [
      "Engineers join your existing sprint process within days",
      "No junior bench — every placement is a senior hire",
      "Scale a single seat or an entire pod",
    ],
  },
  {
    slug: "enterprise-erp-crm",
    name: "Enterprise ERP & CRM",
    short: "Business systems tailored to how your operations actually work.",
    description:
      "We implement, customize, and integrate ERP and CRM systems — or build bespoke alternatives when off-the-shelf platforms force too many compromises on your operations.",
    bullets: [
      "Custom modules on top of existing ERP/CRM platforms",
      "Data migration and legacy system integration",
      "Bespoke builds for workflows no platform supports natively",
    ],
  },
];

export type Project = {
  slug: string;
  name: string;
  category: string;
  summary: string;
  stack: string[];
  outcome: string;
};

export const projects: Project[] = [
  {
    slug: "meridian-claims",
    name: "Meridian Claims",
    category: "Service Platform",
    summary:
      "An end-to-end insurance claims platform replacing a decade-old desktop system used by 40+ regional offices.",
    stack: ["Next.js", "PostgreSQL", "AWS"],
    outcome: "Claim processing time cut from 9 days to 36 hours on average.",
  },
  {
    slug: "norvale-market",
    name: "Norvale Market",
    category: "E-Commerce",
    summary:
      "A headless commerce build for a multi-brand retailer, handling seasonal traffic spikes without a rebuild.",
    stack: ["Next.js", "Shopify Hydrogen", "Redis"],
    outcome: "Handled a 14x Black Friday traffic spike with zero downtime.",
  },
  {
    slug: "atlasboard",
    name: "AtlasBoard",
    category: "Admin Panel",
    summary:
      "An internal operations console giving a logistics network real-time visibility across 200+ fleet vehicles.",
    stack: ["React", "Node.js", "PostGIS"],
    outcome: "Dispatch decisions dropped from minutes to under 10 seconds.",
  },
  {
    slug: "clarive-health",
    name: "Clarive Health",
    category: "Healthcare Platform",
    summary:
      "A HIPAA-aligned patient intake and scheduling system for a multi-clinic healthcare group.",
    stack: ["Next.js", "PostgreSQL", "AWS HIPAA"],
    outcome: "No-show rate reduced by 31% through automated reminders.",
  },
  {
    slug: "ferro-erp",
    name: "Ferro ERP",
    category: "Enterprise ERP",
    summary:
      "A custom manufacturing ERP module built on top of an existing enterprise system that couldn't handle multi-plant inventory.",
    stack: ["Vue", "Django", "Azure"],
    outcome: "Inventory discrepancies across plants dropped by 84%.",
  },
  {
    slug: "lumen-copilot",
    name: "Lumen Copilot",
    category: "AI System",
    summary:
      "An internal support-ticket copilot that drafts and routes responses for a SaaS company's support team.",
    stack: ["Python", "RAG pipeline", "Claude API"],
    outcome: "First-response time down 68%, ticket backlog cleared in 3 weeks.",
  },
];

export type Industry = {
  name: string;
  pitch: string;
};

export const industries: Industry[] = [
  { name: "Startups", pitch: "Ship an MVP that won't need a rebuild after your seed round." },
  { name: "Enterprise", pitch: "Modernize legacy systems without stopping the business that depends on them." },
  { name: "Healthcare & Biolabs", pitch: "Compliant systems for data that can't afford to be wrong." },
  { name: "Logistics & Supply Chain", pitch: "Real-time visibility across fleets, warehouses, and vendors." },
  { name: "GovTech & Public Sector", pitch: "Accessible, auditable systems built for procurement and public trust." },
  { name: "SMEs", pitch: "Enterprise-grade software at a scope that fits your budget." },
  { name: "Fintech & Banking", pitch: "Transaction systems engineered for security and regulatory scrutiny." },
  { name: "E-commerce & Retail", pitch: "Storefronts and backends that hold up under Black Friday load." },
  { name: "EdTech & Learning", pitch: "Learning platforms that stay fast at thousands of concurrent students." },
];
