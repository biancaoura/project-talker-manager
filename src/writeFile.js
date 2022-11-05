const { writeFile } = require('fs').promises;
const path = require('path');

const talkerPath = path.resolve(__dirname, '.', 'talker.json');

const writeNewTalker = async (newTalker) => {
  await writeFile(talkerPath, JSON.stringify(newTalker));
};

module.exports = writeNewTalker;
