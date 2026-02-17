"use client";

import { Info, ChevronDown } from "lucide-react";
import { useState } from "react";

const collectionMethods = [
  { label: "Multiple Choice", selected: false, ai: false },
  { label: "Number", selected: false, ai: false },
  { label: "Date", selected: false, ai: false },
  { label: "Image", selected: false, ai: false },
  { label: "Text Short", selected: false, ai: false },
  { label: "Text Long", selected: false, ai: true },
  { label: "Voice", selected: true, ai: true },
  { label: "Video", selected: false, ai: true },
];

const queryTokens = [
  { type: "tag", value: "IS" },
  { type: "value", value: "Financial Products Used" },
  { type: "tag", value: "WHERE" },
  { type: "value", value: "Bank" },
  { type: "tag", value: "IS" },
  { type: "value", value: "Singapore" },
  { type: "tag", value: "UNDER" },
  { type: "value", value: "Frequency that the individual has opened their mobile app" },
];

const queryRows = [
  { operator: "IS", icon: true, value: "Financial Products Used" },
  { operator: "WHERE", icon: true, value: "Bank" },
  { operator: "WHERE", icon: true, value: "Singapore Bank" },
  { operator: "CREATE", icon: true, value: "Frequency that the individual has opened their mobile app" },
  { operator: "TYPE", icon: true, value: "Number" },
];

export default function ProjectSpecificQuestions() {
  const [selectedMethod, setSelectedMethod] = useState("Voice");

  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        {/* Title */}
        <h2 className="text-[36px] tracking-[-0.72px] leading-none">
          Project-Specific Questions
        </h2>

        {/* Collection Method */}
        <div className="flex flex-col gap-6">
          <p className="text-[20px]">Collection Method</p>
          <div className="flex flex-wrap gap-3 max-w-[824px]">
            {collectionMethods.map((method) => (
              <button
                key={method.label}
                onClick={() => setSelectedMethod(method.label)}
                className={`
                  flex gap-2.5 items-center justify-center px-6 py-3 rounded-xl border transition-colors cursor-pointer
                  ${selectedMethod === method.label
                    ? "bg-black/80 border-black/25 text-white"
                    : "bg-surface border-border text-black hover:border-black/20"
                  }
                `}
              >
                <span className="text-[20px]">{method.label}</span>
                {method.ai && (
                  <span className="bg-accent-yellow text-accent-yellow-text text-[12px] tracking-[-0.12px] px-3 py-1 rounded-lg text-center">
                    AI
                  </span>
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Tied To */}
        <div className="flex flex-col gap-8">
          <div className="flex flex-col gap-6">
            <div className="flex items-center justify-between">
              <p className="text-[20px]">Tied Too</p>
              <Info className="w-[18px] h-[18px] text-black/40" strokeWidth={1.5} />
            </div>

            <div className="flex flex-col gap-2">
              {/* Query Display */}
              <div className="flex gap-3 h-10 items-center">
                <div className="w-[76px] shrink-0">
                  <p className="text-[16px] tracking-[-0.16px]">Query</p>
                </div>
                <div className="flex-1 bg-accent-blue-bg border border-accent-blue rounded h-full flex items-center p-3">
                  <div className="flex gap-1 items-center h-full">
                    {queryTokens.map((token, i) => (
                      <span key={i}>
                        {token.type === "tag" ? (
                          <span className="bg-tag-gray-bg px-1 py-0.5 rounded-xl text-[12px] text-text-secondary text-center tracking-[-0.12px]">
                            {token.value}
                          </span>
                        ) : (
                          <span className="text-accent-blue text-[14px] tracking-[-0.14px]">
                            {token.value}
                          </span>
                        )}
                      </span>
                    ))}
                  </div>
                </div>
              </div>

              {/* Query Rows */}
              {queryRows.map((row, i) => (
                <div key={i} className="flex h-10 items-center">
                  <div className="flex-1 flex h-full items-center justify-end">
                    <div className="bg-tag-gray-bg border-l border-t border-b border-border flex h-full items-center justify-between px-3 py-0.5 rounded-l w-[88px]">
                      <p className="text-[12px] text-text-secondary tracking-[-0.12px]">{row.operator}</p>
                      <ChevronDown className="w-2.5 h-[5px] text-text-secondary" strokeWidth={1.5} />
                    </div>
                  </div>
                  <div className="bg-surface border border-border flex h-full flex-[3] items-center px-3 rounded-r">
                    <p className="text-[14px] tracking-[-0.14px]">{row.value}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Question Prompt */}
          <div className="flex flex-col gap-6">
            <div className="flex items-center justify-between">
              <p className="text-[20px]">Question Prompt</p>
              <Info className="w-[18px] h-[18px] text-black/40" strokeWidth={1.5} />
            </div>
            <div className="bg-black/[0.01] border border-border rounded h-[142px] px-6 py-3">
              <p className="text-[20px] text-text-muted">
                Describe what you want participants to answer. (min 40 words)
              </p>
            </div>
          </div>

          {/* Filtering Criteria */}
          <div className="flex flex-col gap-6">
            <div className="flex items-start justify-between">
              <p className="text-[20px]">Filtering Criteria</p>
              <Info className="w-[18px] h-[18px] text-black/40" strokeWidth={1.5} />
            </div>
            <div className="bg-black/[0.01] border border-border rounded h-[142px] px-6 py-3">
              <p className="text-[20px] text-text-muted leading-relaxed">
                Describe what you want the AI to look for in participants&apos; responses (min 20 words).
              </p>
              <p className="text-[20px] text-text-muted leading-relaxed">
                Example: &quot;Select participants who express uncertainty, frustration, or strong opinions about the feature.&quot;
              </p>
            </div>
          </div>

          {/* Create Filter Button */}
          <div className="flex flex-col gap-3">
            <button className="bg-black/80 border border-black/25 text-white text-[20px] px-6 py-3 rounded w-full cursor-pointer hover:bg-black/90 transition-colors">
              Create Filter
            </button>
            <p className="text-text-muted text-[20px] text-center cursor-pointer hover:text-black/40 transition-colors">
              Clear all
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
