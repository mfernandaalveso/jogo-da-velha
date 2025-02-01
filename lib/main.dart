import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Jogo da Velha'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<String>> board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];

  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;

  // Função para reiniciar o jogo
  void resetGame() {
    setState(() {
      board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', '']
      ];
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
    });
  }

  // Função para lidar com o toque na célula
  void playMove(int row, int col) {
    if (board[row][col] == '' && !gameOver) {
      setState(() {
        board[row][col] = currentPlayer;
        checkWinner();
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';  // Alterna entre X e O
      });
    }
  }

  // Função para verificar se há um vencedor
  void checkWinner() {
    // Verifica as linhas e colunas
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != '') {
        setState(() {
          winner = board[i][0];
          gameOver = true;
        });
        return;
      }
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != '') {
        setState(() {
          winner = board[0][i];
          gameOver = true;
        });
        return;
      }
    }

    // Verifica as diagonais
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != '') {
      setState(() {
        winner = board[0][0];
        gameOver = true;
      });
      return;
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != '') {
      setState(() {
        winner = board[0][2];
        gameOver = true;
      });
      return;
    }

    // Verifica empate
    bool draw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          draw = false;
          break;
        }
      }
    }
    if (draw) {
      setState(() {
        winner = 'Empate';
        gameOver = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título do vencedor
                if (winner.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      winner == 'Empate' ? 'Empate!' : 'Jogador $winner venceu!',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Tabuleiro
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 3; j++)
                              GestureDetector(
                                onTap: () => playMove(i, j),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1),
                                    color: Colors.grey[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      board[i][j],
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: board[i][j] == 'X' ? Colors.blue : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Botão para reiniciar
                ElevatedButton(
                  onPressed: resetGame,
                  child: Text(
                    'Reiniciar Jogo',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



