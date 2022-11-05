const express = require('express');
const { getAllTalkers, getTalkerById } = require('../readFile');
const writeNewTalker = require('../writeFile');
const authentication = require('../middlewares/authentication');
const validateName = require('../middlewares/validateName');
const validateAge = require('../middlewares/validateAge');
const validateTalk = require('../middlewares/validateTalk');
const validateWatchedAt = require('../middlewares/validateWatchedAt');
const validateRate = require('../middlewares/validateRate');
const validateId = require('../middlewares/validateId');

const router = express.Router();

router.get('/', async (_req, res) => {
  const talkers = await getAllTalkers();
  if (talkers) {
    return res.status(200).json(talkers);
  }
  return res.status(200).json([]);
});

router.get('/search', authentication, async (req, res) => {
  const { q } = req.query;
  const talkers = await getAllTalkers();

  if (q) {
    const filteredTalkers = talkers.filter((t) => (t.name).toLowerCase().includes(q.toLowerCase()));
    return res.status(200).json(filteredTalkers);
  }
  return res.status(200).json(talkers);
});

router.get('/:id', async (req, res) => {
  const id = Number(req.params.id);
  const talker = await getTalkerById(id);

  if (talker) {
    return res.status(200).json(talker);
  }
  return res.status(404).json({ message: 'Pessoa palestrante não encontrada' });
});

router.put('/:id',
  authentication,
  validateId,
  validateName,
  validateAge,
  validateTalk,
  validateWatchedAt,
  validateRate,
  async (req, res) => {
    const id = Number(req.params.id);
    const talkers = await getAllTalkers();
    const talker = talkers.find((t) => t.id === id);

    const index = talkers.indexOf(talker);
    const updatedTalker = { id, ...req.body };
    console.log(updatedTalker);
    
    talkers.splice(index, 1, updatedTalker);
    await writeNewTalker(talkers);
    
    return res.status(200).json(updatedTalker);
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

    return res.status(201).json(newTalker);
});

router.delete('/:id',
  authentication,
  validateId,
  async (req, res) => {
    const id = Number(req.params.id);
    const talkers = await getAllTalkers();
    const filteredTalkers = talkers.filter((t) => t.id !== id);
    await writeNewTalker(filteredTalkers);

    return res.status(204).end();
});

module.exports = router;
