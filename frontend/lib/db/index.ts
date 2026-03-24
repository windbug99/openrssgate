import { neon } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';
import * as schema from './schema';

// If DATABASE_URL is not set (e.g., during Vercel build time), use a dummy string 
// to prevent the neon() constructor from throwing an error.
// Actual dynamic queries won't execute at build time thanks to force-dynamic.
const connectionString = process.env.DATABASE_URL || "postgresql://dummy:dummy@dummy/dummy";
const sql = neon(connectionString);

export const db = drizzle(sql, { schema });
