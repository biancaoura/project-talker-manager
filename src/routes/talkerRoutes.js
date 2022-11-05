const express = require('express');
const { getAllTalkers, getTalkerById } = require('../readFile');
const writeNewTalker = require('../writeFile');
const authentication = require('../middlewares/authentication');
const validateName = require('../middlewares/validateName');
const validateAge = require('../middlewares/validateAge');
const validateTalk = require('../middlewares/validateTalk');
const validateWatchedAt = require('../middlewares/validateWatchedAt');
const validateRate = require('../middlewares/validateRate');

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

router.post('/',
  authentication,
  validateName,
  validateAge,
  validateTalk,
  validateWatchedAt,
  validateRate,
  async (req, res) => {
    const { name, age, talk } = req.body;
    const talkers = await getAllTalkers();
    const id = talkers[talkers.length - 1].id + 1;
    const newTalker = { id, name, age, talk };
    
    talkers.push(newTalker);
    await writeNewTalker(talkers);

    res.status(201).json(newTalker);
});

module.exports = router;
