"use client";

import { useState } from "react";
import { ArrowUpRight } from "lucide-react";

type PaymentStatus = "paid" | "payment-issue" | "payment-pending";

interface PaymentRow {
  id: string;
  name: string;
  bank: string;
  accountMask: string;
  status: PaymentStatus;
  amount: string;
  paidOn: string;
}

const statusStyles: Record<PaymentStatus, string> = {
  paid: "bg-accent-green-bg text-accent-green",
  "payment-issue": "bg-accent-red-bg text-accent-red",
  "payment-pending": "bg-tag-gray-bg text-text-secondary",
};

const statusLabels: Record<PaymentStatus, string> = {
  paid: "Paid",
  "payment-issue": "Payment Issue",
  "payment-pending": "Payment Pending",
};

const paymentsData: PaymentRow[] = [
  { id: "1", name: "Alex Turner", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Monday, 10:21 AM" },
  { id: "2", name: "Maya Johnson", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "3", name: "Liam Brown", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "4", name: "Emma Wilson", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "5", name: "Noah Davis", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "6", name: "Olivia Garcia", bank: "Bank ABC", accountMask: "**** 1234", status: "payment-issue", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "7", name: "Ethan Martinez", bank: "Bank ABC", accountMask: "**** 1234", status: "payment-pending", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "8", name: "Sophia Rodriguez", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "9", name: "Aiden Lee", bank: "Bank ABC", accountMask: "**** 1234", status: "paid", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "10", name: "Isabella Hernandez", bank: "Bank ABC", accountMask: "**** 1234", status: "payment-issue", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
  { id: "11", name: "Lucas Lopez", bank: "Bank ABC", accountMask: "**** 1234", status: "payment-issue", amount: "100 SGD", paidOn: "Tuesday, 11:21 AM" },
];

function ActionButton({ row }: { row: PaymentRow }) {
  if (row.status === "payment-issue") {
    return (
      <button className="bg-accent-green text-white rounded-xl px-3 py-1.5 text-[14px] tracking-[-0.14px] flex items-center gap-1 cursor-pointer hover:bg-[#14994f] transition-colors">
        Process Manually
        <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
      </button>
    );
  }
  if (row.status === "payment-pending") {
    return (
      <button className="bg-accent-blue text-white rounded-xl px-3 py-1.5 text-[14px] tracking-[-0.14px] flex items-center gap-1 cursor-pointer hover:bg-[#005ce6] transition-colors">
        Process Payment
        <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
      </button>
    );
  }
  return (
    <button className="flex items-center gap-1 border border-border rounded-xl px-3 py-1.5 text-[14px] tracking-[-0.14px] cursor-pointer hover:bg-black/[0.02] transition-colors">
      Payment Receipt
      <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
    </button>
  );
}

export default function PaymentsTable() {
  const [selected, setSelected] = useState<Set<string>>(new Set(["3", "6", "7"]));
  const [currentPage] = useState(1);

  const toggleRow = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const toggleAll = () => {
    if (selected.size === paymentsData.length) {
      setSelected(new Set());
    } else {
      setSelected(new Set(paymentsData.map((r) => r.id)));
    }
  };

  return (
    <div className="flex flex-col">
      {/* Toolbar */}
      <div className="flex items-center justify-end px-16 py-8 gap-3">
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer">
          Sort by
        </button>
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer flex items-center gap-3">
          <span>Filter</span>
          <div className="flex items-center gap-1">
            <span className="bg-tag-gray-bg px-1.5 py-0.5 rounded text-[12px] tracking-[-0.12px] text-text-secondary">WHERE</span>
            <span className="text-[14px]">Status</span>
            <span className="bg-tag-gray-bg px-1.5 py-0.5 rounded text-[12px] tracking-[-0.12px] text-text-secondary">ISNOT</span>
            <span className="text-[14px]">Paid</span>
          </div>
        </button>
        <button className="bg-[#202020] text-white rounded-xl px-6 py-3 text-[20px] cursor-pointer hover:bg-[#333] transition-colors">
          Process Payments
        </button>
      </div>

      {/* Table */}
      <div className="px-16">
        {/* Header */}
        <div className="flex items-center py-4 border-b border-border">
          <div className="w-[61px] shrink-0 flex items-center justify-center">
            <button
              onClick={toggleAll}
              className={`w-[25px] h-[25px] rounded border cursor-pointer transition-colors ${
                selected.size === paymentsData.length
                  ? "bg-accent-blue border-accent-blue"
                  : "border-border"
              }`}
            />
          </div>
          <span className="flex-1 text-[20px]">Members Name</span>
          <span className="flex-1 text-[20px]">Payout to</span>
          <span className="flex-1 text-[20px]">Payment Status</span>
          <span className="flex-1 text-[20px]">Amount</span>
          <span className="flex-1 text-[20px]">Paid On</span>
          <span className="flex-1 text-[20px]">Actions</span>
        </div>

        {/* Rows */}
        {paymentsData.map((row) => {
          const isSelected = selected.has(row.id);
          return (
            <div
              key={row.id}
              className="flex items-center py-[18px] border-b border-border"
            >
              <div className="w-[61px] shrink-0 flex items-center justify-center">
                <button
                  onClick={() => toggleRow(row.id)}
                  className={`w-[25px] h-[25px] rounded border cursor-pointer transition-colors ${
                    isSelected
                      ? "bg-accent-blue border-accent-blue"
                      : "border-border"
                  }`}
                />
              </div>
              <span className="flex-1 text-[16px] tracking-[-0.16px]">{row.name}</span>
              <div className="flex-1 flex flex-col">
                <span className="text-[16px] tracking-[-0.16px]">{row.bank}</span>
                <span className="text-[10px] text-text-secondary">{row.accountMask}</span>
              </div>
              <div className="flex-1">
                <span className={`${statusStyles[row.status]} px-3 py-1 rounded-xl text-[12px] tracking-[-0.12px]`}>
                  {statusLabels[row.status]}
                </span>
              </div>
              <span className="flex-1 text-[16px] tracking-[-0.16px]">{row.amount}</span>
              <span className="flex-1 text-[16px] tracking-[-0.16px]">{row.paidOn}</span>
              <div className="flex-1 flex gap-3">
                <ActionButton row={row} />
                <button className="flex items-center gap-1 border border-border rounded-xl px-3 py-1.5 text-[14px] tracking-[-0.14px] cursor-pointer hover:bg-black/[0.02] transition-colors">
                  See Profile
                  <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* Pagination */}
      <div className="flex items-center justify-end px-16 py-8 gap-3">
        {[1, 2, 3, 4].map((page) => (
          <button
            key={page}
            className={`w-16 h-16 flex items-center justify-center rounded-xl text-[22px] cursor-pointer transition-colors ${
              page === currentPage
                ? "border border-black text-black"
                : "border border-border text-text-secondary hover:border-black/20"
            }`}
          >
            {page}
          </button>
        ))}
        <span className="w-16 h-16 flex items-center justify-center border border-border rounded-xl text-[22px] text-text-secondary">
          ...
        </span>
      </div>
    </div>
  );
}
