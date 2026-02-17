"use client";

import { Info, ChevronDown, Sparkles } from "lucide-react";
import { useState } from "react";

type Token = { type: "tag" | "value"; value: string };

function FilterTag({ children }: { children: React.ReactNode }) {
  return (
    <span className="bg-black/5 px-1 py-0.5 rounded-xl text-[12px] text-text-secondary text-center tracking-[-0.12px]">
      {children}
    </span>
  );
}

function OperatorDropdown({ value }: { value: string }) {
  return (
    <div className="bg-black/5 border-l border-t border-b border-border flex h-10 items-center justify-between px-3 py-0.5 rounded-bl rounded-tl w-[88px] shrink-0 cursor-pointer">
      <p className="text-[12px] text-text-secondary tracking-[-0.12px]">{value}</p>
      <ChevronDown className="w-2.5 h-[5px] text-text-secondary" strokeWidth={2} />
    </div>
  );
}

function BuilderRow({ operator, value, emptyValue }: { operator: string; value?: string; emptyValue?: boolean }) {
  return (
    <div className="flex h-10 items-center justify-end w-full">
      <div className="flex h-full items-center justify-end shrink-0">
        <OperatorDropdown value={operator} />
      </div>
      {emptyValue ? (
        <div className="bg-[#f2f2f2] border border-border h-full rounded-br rounded-tr shrink-0 w-[364px]" />
      ) : (
        <div className="bg-white border border-border flex h-full items-center p-3 rounded-br rounded-tr shrink-0 w-[364px]">
          {value && (
            <p className="text-[14px] text-black tracking-[-0.14px]">{value}</p>
          )}
        </div>
      )}
    </div>
  );
}

function EmptyInput() {
  return (
    <div className="bg-[#fbfbfb] border border-border flex items-center justify-between px-3 py-2 rounded w-[364px] h-10" />
  );
}

function ActiveInput({ tokens }: { tokens: Token[] }) {
  return (
    <div className="bg-[rgba(1,111,255,0.05)] border border-accent-blue flex h-10 items-center p-3 rounded w-[364px]">
      <div className="flex gap-1 items-center h-full">
        {tokens.map((token, i) => (
          <span key={i}>
            {token.type === "tag" ? (
              <FilterTag>{token.value}</FilterTag>
            ) : (
              <span className="text-accent-blue text-[14px] tracking-[-0.14px]">{token.value}</span>
            )}
          </span>
        ))}
      </div>
    </div>
  );
}

function SavedInput({ lines }: { lines: Token[][] }) {
  return (
    <div className="bg-white border border-border flex flex-col gap-2 items-start p-3 rounded w-[364px]">
      {lines.map((tokens, lineIdx) => (
        <div key={lineIdx} className="flex gap-1 items-center w-full">
          {tokens.map((token, i) => (
            <span key={i}>
              {token.type === "tag" ? (
                <FilterTag>{token.value}</FilterTag>
              ) : (
                <span className="text-[14px] text-black tracking-[-0.14px]">{token.value}</span>
              )}
            </span>
          ))}
        </div>
      ))}
    </div>
  );
}

function FilterFieldRow({ label, children }: { label: string | React.ReactNode; children: React.ReactNode }) {
  return (
    <div className="flex items-center justify-between w-full">
      <div className="w-[115px] shrink-0">
        {typeof label === "string" ? (
          <p className="text-[16px] tracking-[-0.16px]">{label}</p>
        ) : (
          label
        )}
      </div>
      {children}
    </div>
  );
}

function CollapsedFilter({ title, noBorder }: { title: string; noBorder?: boolean }) {
  return (
    <div className={`${noBorder ? "" : "border-b border-border"} flex items-center justify-between px-6 py-8 w-full shadow-[0px_4px_4px_0px_rgba(0,0,0,0.02)]`}>
      <p className="text-[20px]">{title}</p>
      <Info className="w-[18px] h-[18px] text-black/40" strokeWidth={1.5} />
    </div>
  );
}

export default function SegmentationPanel() {
  const [aiExpanded] = useState(true);

  return (
    <div className="w-[540px] shrink-0 flex flex-col items-end">
      {/* Segment with AI */}
      <div className="bg-accent-yellow flex flex-col w-full rounded-xl overflow-hidden mb-6">
        <button className="flex items-center justify-center gap-2 px-6 py-3 cursor-pointer hover:bg-[#fff3a0] transition-colors">
          <Sparkles className="w-4 h-4 text-accent-yellow-text" strokeWidth={1.5} />
          <span className="text-[16px] tracking-[-0.16px] text-accent-yellow-text">Segment with AI</span>
        </button>
        {aiExpanded && (
          <div className="bg-accent-yellow p-1">
            <div className="bg-surface rounded-xl h-[96px] p-4">
              <p className="text-[16px] tracking-[-0.16px] text-text-muted">
                Enter your definition segmentation
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Manual Segmentation Tab */}
      <div className="flex w-full">
        <div className="bg-accent-blue-light flex items-center justify-center px-6 py-3 rounded-tl-xl rounded-tr-xl flex-1">
          <p className="text-[16px] tracking-[-0.16px]">Manual Segmentation</p>
        </div>
      </div>

      {/* Manual Segmentation Content — no gap from tab above */}
      <div className="bg-accent-blue-light p-1 w-full">
        <div className="bg-surface rounded-xl flex flex-col p-2">
          {/* Filter By Demographics */}
          <div className="border-b border-border flex flex-col gap-12 px-6 py-8 shadow-[0px_4px_4px_0px_rgba(0,0,0,0.02)]">
            <div className="flex items-center justify-between w-full">
              <p className="text-[20px]">Filter By Demographics</p>
              <Info className="w-[18px] h-[18px] text-black/40" strokeWidth={1.5} />
            </div>

            <div className="flex flex-col gap-3">
              {/* Age - active (blue border) */}
              <FilterFieldRow label="Age">
                <ActiveInput tokens={[
                  { type: "tag", value: "IS" },
                  { type: "value", value: "24" },
                ]} />
              </FilterFieldRow>

              {/* Age builder row */}
              <BuilderRow operator="IS" value="24" />

              {/* Gender - empty */}
              <FilterFieldRow label="Gender">
                <EmptyInput />
              </FilterFieldRow>

              {/* Occupation - empty */}
              <FilterFieldRow label="Occupation">
                <EmptyInput />
              </FilterFieldRow>

              {/* Income - saved multi-line */}
              <FilterFieldRow label="Income">
                <SavedInput lines={[
                  [
                    { type: "tag", value: "WHERE" },
                    { type: "value", value: "Currency" },
                    { type: "tag", value: "CONTAINS" },
                    { type: "value", value: "USD" },
                  ],
                  [
                    { type: "tag", value: "FROM" },
                    { type: "value", value: "4400" },
                    { type: "tag", value: "TO" },
                    { type: "value", value: "6400" },
                  ],
                ]} />
              </FilterFieldRow>

              {/* Education - saved multi-line */}
              <FilterFieldRow label="Education">
                <SavedInput lines={[
                  [
                    { type: "tag", value: "WHERE" },
                    { type: "value", value: "Studies" },
                    { type: "tag", value: "CONTAINS" },
                    { type: "value", value: "Engineering" },
                  ],
                  [
                    { type: "tag", value: "AND" },
                    { type: "value", value: "Bachelors" },
                    { type: "tag", value: "IS" },
                    { type: "value", value: "True" },
                  ],
                ]} />
              </FilterFieldRow>

              {/* Ethnicity - empty */}
              <FilterFieldRow label="Ethnicity">
                <EmptyInput />
              </FilterFieldRow>

              {/* Location - saved multi-line */}
              <FilterFieldRow label="Location">
                <SavedInput lines={[
                  [
                    { type: "tag", value: "WHERE" },
                    { type: "value", value: "Country" },
                    { type: "tag", value: "IS" },
                    { type: "value", value: "Singapore" },
                  ],
                  [
                    { type: "tag", value: "AND" },
                    { type: "value", value: "City" },
                    { type: "tag", value: "IS" },
                    { type: "value", value: "Singapore" },
                  ],
                  [
                    { type: "tag", value: "OR" },
                    { type: "tag", value: "WHERE" },
                    { type: "value", value: "Country" },
                    { type: "tag", value: "IS" },
                    { type: "value", value: "Malaysia" },
                  ],
                  [
                    { type: "tag", value: "AND" },
                    { type: "value", value: "City" },
                    { type: "tag", value: "IS" },
                    { type: "value", value: "Kuala Lampur" },
                  ],
                ]} />
              </FilterFieldRow>

              {/* Location builder rows */}
              <BuilderRow operator="WHERE" value="Country" />
              <BuilderRow operator="IS" value="Singapore" />
              <BuilderRow operator="AND" value="City" />
              <BuilderRow operator="IS" value="Singapore" />
              <BuilderRow operator="OR" emptyValue />
              <BuilderRow operator="WHERE" value="Country" />
              <BuilderRow operator="IS" value="Malaysia" />
              <BuilderRow operator="AND" value="City" />
              <BuilderRow operator="IS" value="Kuala Lampur" />

              {/* Probability of human - saved */}
              <FilterFieldRow label={
                <p className="text-[16px] tracking-[-0.16px]">
                  Probability of<br />human
                </p>
              }>
                <SavedInput lines={[
                  [
                    { type: "tag", value: "FROM" },
                    { type: "value", value: "70" },
                  ],
                ]} />
              </FilterFieldRow>

              {/* Disability - saved */}
              <FilterFieldRow label="Disability">
                <SavedInput lines={[
                  [
                    { type: "tag", value: "FROM" },
                    { type: "value", value: "70" },
                  ],
                ]} />
              </FilterFieldRow>

              {/* Appearance - saved */}
              <FilterFieldRow label="Appearance">
                <SavedInput lines={[
                  [
                    { type: "tag", value: "FROM" },
                    { type: "value", value: "70" },
                  ],
                ]} />
              </FilterFieldRow>
            </div>
          </div>

          {/* Filter By Household & Financial Situation */}
          <div className="border-b border-border flex flex-col gap-12 px-6 py-8 shadow-[0px_4px_4px_0px_rgba(0,0,0,0.02)]">
            <div className="flex items-center justify-between w-full">
              <p className="text-[20px]">Filter By Household & Financial Situation</p>
              <Info className="w-[18px] h-[18px] text-black/40" strokeWidth={1.5} />
            </div>

            <div className="flex flex-col gap-3">
              <FilterFieldRow label={
                <p className="text-[16px] tracking-[-0.16px]">Housing situation</p>
              }>
                <EmptyInput />
              </FilterFieldRow>

              <FilterFieldRow label={
                <p className="text-[16px] tracking-[-0.16px]">Property ownership</p>
              }>
                <EmptyInput />
              </FilterFieldRow>

              {/* Vehicles - saved multi-line */}
              <FilterFieldRow label="Vehicles">
                <SavedInput lines={[
                  [
                    { type: "tag", value: "WHERE" },
                    { type: "value", value: "Car owned" },
                    { type: "tag", value: "CONTAINS" },
                    { type: "value", value: "Mercedes" },
                  ],
                  [
                    { type: "tag", value: "AND" },
                    { type: "value", value: "Quoted" },
                    { type: "tag", value: "CONTAINS" },
                    { type: "value", value: "driving fast" },
                  ],
                ]} />
              </FilterFieldRow>

              {/* Financial products used - active (blue border) */}
              <FilterFieldRow label={
                <p className="text-[16px] tracking-[-0.16px]">
                  Financial<br />products used
                </p>
              }>
                <ActiveInput tokens={[
                  { type: "tag", value: "WHERE" },
                  { type: "value", value: "Monthly Spend" },
                  { type: "tag", value: "FROM" },
                  { type: "value", value: "10,000" },
                ]} />
              </FilterFieldRow>

              {/* Financial products builder rows */}
              <BuilderRow operator="WHERE" value="Monthly spend" />
              <BuilderRow operator="FROM" value="10,000" />

              <FilterFieldRow label={
                <p className="text-[16px] tracking-[-0.16px]">Household size</p>
              }>
                <EmptyInput />
              </FilterFieldRow>

              <FilterFieldRow label="Dependents">
                <EmptyInput />
              </FilterFieldRow>
            </div>
          </div>

          {/* Collapsed filter sections */}
          <CollapsedFilter title="Filter By Lifestyle & Habits" />
          <CollapsedFilter title="Filter By Culture & Language" />
          <CollapsedFilter title="Filter By Personality Traits" noBorder />
        </div>
      </div>

      {/* Clear all */}
      <div className="flex items-center justify-center py-6 w-full">
        <p className="text-text-muted text-[20px] cursor-pointer hover:text-black/40 transition-colors">
          Clear all
        </p>
      </div>
    </div>
  );
}
