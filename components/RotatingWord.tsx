"use client";

import { useEffect, useState } from "react";

export default function RotatingWord({ words, delay = 0 }: { words: string[]; delay?: number }) {
  const [index, setIndex] = useState(0);
  const [visible, setVisible] = useState(true);

  useEffect(() => {
    const start = setTimeout(() => {
      const interval = setInterval(() => {
        setVisible(false);
        setTimeout(() => {
          setIndex((prev) => (prev + 1) % words.length);
          setVisible(true);
        }, 260);
      }, 2800);
      return () => clearInterval(interval);
    }, delay);
    return () => clearTimeout(start);
  }, [words.length, delay]);

  return (
    <span
      className="gradient-headline inline-block transition-opacity duration-300"
      style={{ opacity: visible ? 1 : 0 }}
    >
      {words[index]}
    </span>
  );
}
