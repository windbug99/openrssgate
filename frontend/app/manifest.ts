import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "OpenRSSGate",
    short_name: "OpenRSSGate",
    description: "Central RSS source index for people and AI.",
    start_url: "/",
    display: "standalone",
    background_color: "#0a0a0a",
    theme_color: "#0a0a0a",
    lang: "en",
  };
}
