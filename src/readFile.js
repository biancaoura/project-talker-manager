const { readFile } = require('fs').promises;
const path = require('path');

const talkerPath = path.resolve(__dirname, '.', 'talker.json');

const readTalkers = async () => {
  const response = await readFile(talkerPath, 'utf-8');
  return JSON.parse(response);
};

module.exports = {
  readTalkers,
};
