const { getAllTalkers } = require('../readFile');

module.exports = async (req, res, next) => {
  const id = Number(req.params.id);
  const talkers = await getAllTalkers();

  const talker = talkers.some((t) => t.id === id);
  if (!talker) {
    return res.status(404).json({ message: 'Pessoa palestrante não encontrada' });
  }

  next();
};
