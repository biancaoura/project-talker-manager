const { readFile } = require('fs').promises;
const path = require('path');

const talkerPath = path.resolve(__dirname, '.', 'talker.json');

const getAllTalkers = async () => {
  const response = await readFile(talkerPath, 'utf-8');
  return JSON.parse(response);
};

const getTalkerById = async (id) => {
  const talkers = await getAllTalkers();
  return talkers.find((talker) => talker.id === id);
};

module.exports = {
  getAllTalkers,
  getTalkerById,
};
