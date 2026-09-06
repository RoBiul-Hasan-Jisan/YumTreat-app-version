"use client";

import { useState, FormEvent } from "react";

const budgets = ["< $10k", "$10k – $50k", "$50k – $150k", "$150k+", "Not sure yet"];

export default function ContactForm() {
  const [submitted, setSubmitted] = useState(false);

  function handleSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSubmitted(true);
  }

  if (submitted) {
    return (
      <div className="hairline rounded-lg bg-ink-800 p-10 text-center">
        <h3 className="font-display text-[20px] font-medium text-ink-50">Message received</h3>
        <p className="mt-2 text-[14.5px] text-ink-300">
          We reply to every inquiry within one business day. Talk soon.
        </p>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="hairline rounded-lg bg-ink-800 p-6 md:p-8">
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
        <div>
          <label className="text-[13px] text-ink-300" htmlFor="name">Name</label>
          <input
            id="name"
            required
            className="mt-2 w-full rounded-sm border border-ink-600 bg-ink-900 px-3.5 py-2.5 text-[14.5px] text-ink-50 outline-none placeholder:text-ink-500 focus:border-brass/60"
            placeholder="Jane Doe"
          />
        </div>
        <div>
          <label className="text-[13px] text-ink-300" htmlFor="email">Email</label>
          <input
            id="email"
            type="email"
            required
            className="mt-2 w-full rounded-sm border border-ink-600 bg-ink-900 px-3.5 py-2.5 text-[14.5px] text-ink-50 outline-none placeholder:text-ink-500 focus:border-brass/60"
            placeholder="jane@company.com"
          />
        </div>
      </div>

      <div className="mt-5">
        <label className="text-[13px] text-ink-300" htmlFor="company">Company</label>
        <input
          id="company"
          className="mt-2 w-full rounded-sm border border-ink-600 bg-ink-900 px-3.5 py-2.5 text-[14.5px] text-ink-50 outline-none placeholder:text-ink-500 focus:border-brass/60"
          placeholder="Company name"
        />
      </div>

      <div className="mt-5">
        <label className="text-[13px] text-ink-300">Estimated budget</label>
        <div className="mt-2 flex flex-wrap gap-2">
          {budgets.map((b) => (
            <label
              key={b}
              className="hairline cursor-pointer rounded-sm px-3 py-1.5 text-[13px] text-ink-300 has-[:checked]:border-brass has-[:checked]:text-brass"
            >
              <input type="radio" name="budget" value={b} className="hidden" />
              {b}
            </label>
          ))}
        </div>
      </div>

      <div className="mt-5">
        <label className="text-[13px] text-ink-300" htmlFor="message">Tell us about the project</label>
        <textarea
          id="message"
          required
          rows={5}
          className="mt-2 w-full rounded-sm border border-ink-600 bg-ink-900 px-3.5 py-2.5 text-[14.5px] text-ink-50 outline-none placeholder:text-ink-500 focus:border-brass/60"
          placeholder="What are you building, and what's the timeline?"
        />
      </div>

      <button
        type="submit"
        className="mt-6 w-full rounded-sm bg-brass px-6 py-3 text-[14.5px] font-medium text-ink-900 transition-opacity hover:opacity-90 sm:w-auto"
      >
        Send message
      </button>
    </form>
  );
}
