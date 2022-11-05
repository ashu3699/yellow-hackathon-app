const router = require('express').Router();

const sw = require('./sw');

router.get('/expenses', (req, res) => {
    sw.getExpenses().then(expenses => {
        res.json(expenses);
    });
})

router.get('/groups', (req, res) => {
    sw.getGroups().then(groups => {
        res.json(groups);
    });
})

router.get('/friends', (req, res) => {
    sw.getFriends().then(friends => {
        res.json(friends);
    });
})

router.get('/users', (req, res) => {
    sw.getUsers().then(users => {
        res.json(users);
    });
})

router.get('/currentuser', (req, res) => {
    sw.getCurrentUser().then(user => {
        res.json(user);
    });
})

router.get('/currencies', (req, res) => {
    sw.getCurrencies().then(currencies => {
        res.json(currencies);
    });
})

router.get('/categories', (req, res) => {
    sw.getCategories().then(categories => {
        res.json(categories);
    });
})

router.get('/payments', (req, res) => {
    sw.getPayments().then(payments => {
        res.json(payments);
    });
})

router.get('/comments', (req, res) => {
    sw.getComments().then(comments => {
        res.json(comments);
    });
})

router.get('/notifications', (req, res) => {
    sw.getNotifications().then(notifications => {
        res.json(notifications);
    });
})

router.get('/balances', (req, res) => {
    sw.getBalances().then(balances => {
        res.json(balances);
    });
})


module.exports = router;