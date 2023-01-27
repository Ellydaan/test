const express = require('express');
const mysql = require('mysql');
const app = express();
const cors= require ('cors')
app.use(express.json());
app.use(cors());
const PORT = 3001



app.listen(PORT, () => {
        // Fonction éxecutée lorsque l'application a démarré
        console.log('Serveur démarré : http://localhost:3001')
            })

let pool = mysql.createConnection({
        host: 'localhost',
        user : 'user',
        password  : 'Mot2passe',
        database : 'pokedex',
})



app.get('/pokedex',  (req, res) => {
        let sql = 'SELECT * FROM pokedex\n' +
            '            JOIN stats ON pokedex.id_pok = stats.pokemon_id\n' +
            '            JOIN  types ON pokedex.id_pok = types.id_pok\n' +
            '            JOIN weaknesses ON pokedex.id_pok= weaknesses.pokedex_id';
        let query = pool.query(sql, (err, result) => {
                if (err) {
                        let error = {
                                "code": err.errno,
                                "message": err.message

                        }

                        res.status(err.errno).send(error)
                }
                res.send(result)
        })
})

app.get('/pokedex',  (req, res) => {
        let sql = 'SELECT * FROM pokedex\n' +
            '            JOIN stats ON pokedex.id_pok = stats.pokemon_id\n' +
            '            JOIN  types ON pokedex.id_pok = types.id_pok\n' +
            '            JOIN weaknesses ON pokedex.id_pok= weaknesses.pokedex_id';
        let query = pool.query(sql, (err, result) => {
                if (err) {
                        let error = {
                                "code": err.errno,
                                "message": err.message

                        }

                        res.status(err.errno).send(error)
                }
                res.send(result)
        })
})






