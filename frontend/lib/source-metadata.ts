export const LANGUAGE_OPTIONS = [
  { value: "en", label: "English" },
  { value: "zh", label: "Chinese" },
  { value: "es", label: "Spanish" },
  { value: "ar", label: "Arabic" },
  { value: "pt", label: "Portuguese" },
  { value: "ru", label: "Russian" },
  { value: "ja", label: "Japanese" },
  { value: "de", label: "German" },
  { value: "fr", label: "French" },
  { value: "ko", label: "Korean" },
  { value: "hi", label: "Hindi" },
  { value: "id", label: "Indonesian" },
  { value: "tr", label: "Turkish" },
  { value: "other", label: "Other" },
] as const;

export const SOURCE_TYPE_OPTIONS = [
  { value: "blog", label: "Blog" },
  { value: "news", label: "News" },
  { value: "magazine", label: "Magazine" },
  { value: "newsletter", label: "Newsletter" },
  { value: "podcast", label: "Podcast" },
  { value: "forum", label: "Forum" },
  { value: "documentation", label: "Documentation" },
  { value: "research", label: "Research" },
  { value: "video", label: "Video" },
  { value: "other", label: "Other" },
] as const;

export const SOURCE_CATEGORY_OPTIONS = [
  { value: "tech", label: "Tech" },
  { value: "business", label: "Business" },
  { value: "finance", label: "Finance" },
  { value: "science", label: "Science" },
  { value: "health", label: "Health" },
  { value: "education", label: "Education" },
  { value: "design", label: "Design" },
  { value: "culture", label: "Culture" },
  { value: "entertainment", label: "Entertainment" },
  { value: "gaming", label: "Gaming" },
  { value: "sports", label: "Sports" },
  { value: "lifestyle", label: "Lifestyle" },
  { value: "travel", label: "Travel" },
  { value: "food", label: "Food" },
  { value: "fashion", label: "Fashion" },
  { value: "hobby", label: "Hobby" },
  { value: "automotive", label: "Automotive" },
  { value: "politics", label: "Politics" },
  { value: "security", label: "Security" },
  { value: "environment", label: "Environment" },
  { value: "media", label: "Media" },
  { value: "other", label: "Other" },
] as const;

export const SOURCE_TAG_OPTIONS = [
  { value: "ai", label: "AI" },
  { value: "opensource", label: "Open Source" },
  { value: "startup", label: "Startup" },
  { value: "investing", label: "Investing" },
  { value: "economy", label: "Economy" },
  { value: "programming", label: "Programming" },
  { value: "webdev", label: "Web Dev" },
  { value: "mobile", label: "Mobile" },
  { value: "backend", label: "Backend" },
  { value: "frontend", label: "Frontend" },
  { value: "devops", label: "DevOps" },
  { value: "cloud", label: "Cloud" },
  { value: "cybersecurity", label: "Cybersecurity" },
  { value: "data", label: "Data" },
  { value: "machine-learning", label: "Machine Learning" },
  { value: "product", label: "Product" },
  { value: "ux", label: "UX" },
  { value: "marketing", label: "Marketing" },
  { value: "leadership", label: "Leadership" },
  { value: "career", label: "Career" },
  { value: "productivity", label: "Productivity" },
  { value: "analysis", label: "Analysis" },
  { value: "tutorial", label: "Tutorial" },
  { value: "opinion", label: "Opinion" },
  { value: "review", label: "Review" },
  { value: "interview", label: "Interview" },
  { value: "curation", label: "Curation" },
  { value: "daily", label: "Daily" },
  { value: "weekly", label: "Weekly" },
  { value: "local", label: "Local" },
  { value: "global", label: "Global" },
  { value: "beginner", label: "Beginner" },
  { value: "advanced", label: "Advanced" },
  { value: "other", label: "Other" },
] as const;

export const SOURCE_LIMITS = {
  maxCategories: 2,
  maxTags: 3,
} as const;

export type LanguageCode = (typeof LANGUAGE_OPTIONS)[number]["value"];
export type SourceType = (typeof SOURCE_TYPE_OPTIONS)[number]["value"];
export type SourceCategory = (typeof SOURCE_CATEGORY_OPTIONS)[number]["value"];
export type SourceTag = (typeof SOURCE_TAG_OPTIONS)[number]["value"];

function buildLabelMap<T extends readonly { value: string; label: string }[]>(options: T) {
  return Object.fromEntries(options.map((option) => [option.value, option.label])) as Record<T[number]["value"], string>;
}

export const LANGUAGE_LABELS = buildLabelMap(LANGUAGE_OPTIONS);
export const SOURCE_TYPE_LABELS = buildLabelMap(SOURCE_TYPE_OPTIONS);
export const SOURCE_CATEGORY_LABELS = buildLabelMap(SOURCE_CATEGORY_OPTIONS);
export const SOURCE_TAG_LABELS = buildLabelMap(SOURCE_TAG_OPTIONS);
