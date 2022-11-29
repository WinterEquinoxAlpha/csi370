#include <iostream>

using std::cout;
using std::cin;

char boardValues[] = {' ',' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '};
char board[] = {' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','\n'};
const int boardSize = 58;
bool Xturn = true;
bool gameOver = false;

void printBoard(char b[], const int bs)
{
	for (int i = 0; i < bs; ++i)
	{
		cout << b[i];
	}
}


// 1, 5, 9
// 24, 28, 32
// 47, 51, 55
void updateBoard(char b[], char bv[])
{
	b[1] = bv[0];
	b[5] = bv[1];
	b[9] = bv[2];
	b[24] = bv[3];
	b[28] = bv[4];
	b[32] = bv[5];
	b[47] = bv[6];
	b[51] = bv[7];
	b[55] = bv[8];
}

int getInput(bool& turn)
{
	int move = 0;
	char c = 79 + 9 * turn;
	cout << c << " Turn\nEnter Move: ";
	cin >> move;
	return move;
}

bool checkGameOver(char bv[])
{
	bool boardFull = true;
	for (int i = 0; i < 9; ++i)
	{
		if (bv[i] == ' ')
		{
			boardFull = false;
			break;
		}
	}
	if (boardFull)
	{
		return true;
	}

	if (bv[0] == 'X' && bv[3] == 'X' && bv[6] == 'X')
	{
		return true;
	}
	if (bv[1] == 'X' && bv[4] == 'X' && bv[7] == 'X')
	{
		return true;
	}
	if (bv[2] == 'X' && bv[5] == 'X' && bv[8] == 'X')
	{
		return true;
	}
	if (bv[0] == 'X' && bv[1] == 'X' && bv[2] == 'X')
	{
		return true;
	}
	if (bv[3] == 'X' && bv[4] == 'X' && bv[5] == 'X')
	{
		return true;
	}
	if (bv[6] == 'X' && bv[7] == 'X' && bv[8] == 'X')
	{
		return true;
	}
	if (bv[0] == 'X' && bv[4] == 'X' && bv[8] == 'X')
	{
		return true;
	}
	if (bv[2] == 'X' && bv[4] == 'X' && bv[6] == 'X')
	{
		return true;
	}

	return false;
}

int main()
{
	while (!gameOver)
	{
		updateBoard(board, boardValues);
		printBoard(board, boardSize);

		int move = -1;
		while (move == -1)
		{
			move = getInput(Xturn);
			cout << move << std::endl;
			if (move < 0 || move > 8)
			{
				cout << "Move out of range 0-8\n\n";
				move = -1;
				continue;
			}
			if (boardValues[move] != ' ')
			{
				cout << "Position taken\n\n";
				move = -1;
				continue;
			}
		}

		char c = 79 + 9 * Xturn;
		boardValues[move] = c;
		Xturn = !Xturn;

		gameOver = checkGameOver(boardValues);
	}

	updateBoard(board, boardValues);
	printBoard(board, boardSize);
	cout << "Game Over";
}
