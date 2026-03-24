import { neon } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';
import * as schema from './schema';

let dbInstance: any;

export function getDb() {
  if (dbInstance) return dbInstance;
  
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error('DATABASE_URL environment variable is not set');
  }
  
  const sql = neon(connectionString);
  dbInstance = drizzle(sql, { schema });
  return dbInstance;
}

// Export a proxy or just the function
export const db = new Proxy({} as any, {
  get(target, prop) {
    return getDb()[prop];
  }
});
