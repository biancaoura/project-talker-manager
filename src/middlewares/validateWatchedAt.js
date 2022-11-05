module.exports = (req, res, next) => {
  const { watchedAt } = req.body.talk;
  const regex = /(0[1-9]|[12]\d|3[01])\/(0[1-9]|1[012])\/(19|20)\d{2}/;

  if (!watchedAt) {
    return res.status(400).json({ message: 'O campo "watchedAt" é obrigatório' });
  }

  if (!regex.test(watchedAt)) {
    return res.status(400).json({ message: 'O campo "watchedAt" deve ter o formato "dd/mm/aaaa"' });
  }

  next();
};
