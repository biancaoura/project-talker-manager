const express = require('express');
const { getAllTalkers, getTalkerById } = require('../readFile');

const router = express.Router();

router.get('/', async (_req, res) => {
  const talkers = await getAllTalkers();
  if (talkers) {
    return res.status(200).json(talkers);
  }
  return res.status(200).json([]);
});

router.get('/:id', async (req, res) => {
  const id = Number(req.params.id);
  const talker = await getTalkerById(id);

  if (talker) {
    return res.status(200).json(talker);
  }
  return res.status(404).json({ message: 'Pessoa palestrante não encontrada' });
});

module.exports = router;