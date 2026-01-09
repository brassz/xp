import fs from 'node:fs';
import path from 'node:path';

function todayKey(d = new Date()) {
  return d.toISOString().slice(0, 10);
}

export class SentStore {
  constructor({ filePath }) {
    this.filePath = filePath;
    this.cache = null;
  }

  _load() {
    if (this.cache) return this.cache;
    try {
      const raw = fs.readFileSync(this.filePath, 'utf8');
      this.cache = JSON.parse(raw);
    } catch {
      this.cache = {};
    }
    return this.cache;
  }

  _save() {
    const dir = path.dirname(this.filePath);
    fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(this.filePath, JSON.stringify(this.cache ?? {}, null, 2));
  }

  hasSentToday(messageKey) {
    const db = this._load();
    return db[messageKey] === todayKey();
  }

  markSent(messageKey) {
    const db = this._load();
    db[messageKey] = todayKey();
    this._save();
  }
}

