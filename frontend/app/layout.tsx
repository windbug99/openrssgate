import type { Metadata } from "next";
import localFont from "next/font/local";
import type { ReactNode } from "react";

import "./globals.css";

const geistSans = localFont({
  src: [
    {
      path: "./fonts/geist-latin.woff2",
      weight: "100 900",
      style: "normal",
    },
    {
      path: "./fonts/geist-latin-ext.woff2",
      weight: "100 900",
      style: "normal",
    },
  ],
  variable: "--font-geist-sans",
});

const geistMono = localFont({
  src: [
    {
      path: "./fonts/geist-mono-latin.woff2",
      weight: "100 900",
      style: "normal",
    },
    {
      path: "./fonts/geist-mono-latin-ext.woff2",
      weight: "100 900",
      style: "normal",
    },
  ],
  variable: "--font-geist-mono",
});

const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "http://127.0.0.1:3000";

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: {
    default: "OpenRSSGate",
    template: "%s | OpenRSSGate",
  },
  description: "Central RSS source index for people and AI.",
  applicationName: "OpenRSSGate",
  alternates: {
    canonical: "/",
  },
  openGraph: {
    title: "OpenRSSGate",
    description: "Central RSS source index for people and AI.",
    url: "/",
    siteName: "OpenRSSGate",
    locale: "en_US",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "OpenRSSGate",
    description: "Central RSS source index for people and AI.",
  },
  icons: {
    icon: [
      { url: "/favicon-light.svg", media: "(prefers-color-scheme: light)", type: "image/svg+xml" },
      { url: "/favicon-dark.svg", media: "(prefers-color-scheme: dark)", type: "image/svg+xml" },
    ],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
      "max-video-preview": -1,
    },
  },
  manifest: "/manifest.webmanifest",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en" className="dark" suppressHydrationWarning>
      <body className={`${geistSans.variable} ${geistMono.variable}`}>{children}</body>
    </html>
  );
}
