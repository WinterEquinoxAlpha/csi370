#include <iostream>
#include <algorithm>

using std::cout;
using std::cin;

char boardValues[] = {' ',' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '};
char board[] = {' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','\n'};
const int boardSize = 58;
bool Xturn = true;
int gameOver = -1;
bool ai = true;

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

// l = 0-2: Vertical lines
// l = 3-5: Horrizontal lines
// l = 6-7: Diagonal lines
bool checkLine(char bv[], int l, char c)
{
	if (l < 3)
	{
		return (bv[l] == c && bv[l + 3] == c && bv[l + 6] == c);
	}
	if (l >= 3 && l < 6)
	{
		int i = (l - 3) * 3;
		return (bv[i] == c && bv[i + 1] == c && bv[i + 2] == c);
	}
	int i = (l - 6) * 2;
	return (bv[i] == c && bv[4] == c && bv[8 - i] == c);
}

int countCharsInLine(char bv[], int l, char c)
{
	if (l < 3)
	{
		return (int)(bv[l] == c) + (int)(bv[l + 3] == c) + (int)(bv[l + 6] == c);
	}
	if (l >= 3 && l < 6)
	{
		int i = (l - 3) * 3;
		return (int)(bv[i] == c) + (int)(bv[i + 1] == c) + (int)(bv[i + 2] == c);
	}
	int i = (l - 6) * 2;
	return (int)(bv[i] == c) + (int)(bv[4] == c) + (int)(bv[8 - i] == c);
}

int checkGameOver(char bv[])
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
		return 0;

	for (int i = 0; i < 8; ++i)
	{
		if (checkLine(bv, i, 'X'))
			return 1;

		if (checkLine(bv, i, 'O'))
			return 2;
	}

	return -1;
}

int evaluateBoard(char bv[])
{
	int score = checkGameOver(bv);
	if (score == 1)
	{
		return INT_MIN;
	}
	if (score == 2)
	{
		return INT_MAX;
	}

	int x1 = 0;
	int x2 = 0;
	int o1 = 0;
	int o2 = 0;

	for (int i = 0; i < 8; ++i)
	{
		int x = countCharsInLine(bv, i, 'X');
		x1 += (x == 1);
		x2 += (x == 2);

		int o = countCharsInLine(bv, i, 'O');
		o1 += (o == 1);
		o2 += (o == 2);
	}

	return 3 * o2 + o1 - (3 * x2 + x1);
}

int minimax(char bv[], int depth, bool maximizer)
{
	int score = checkGameOver(bv);
	if (score == 0)
		return 0;
	if (score == 1)
		return INT_MIN;
	if (score == 2)
		return INT_MAX;

	if (maximizer)
	{
		int best = INT_MIN;

		for (int i = 0; i < 9; ++i)
		{
			if (bv[i] == ' ')
			{
				bv[i] = 'O';
				best = std::max(best, minimax(board, depth + 1, !maximizer));
				bv[i] = ' ';
			}
		}
		return best;
	}
	else
	{
		int best = INT_MAX;

		// Traverse all cells
		for (int i = 0; i < 9; ++i)
		{
			if (bv[i] == ' ')
			{
				bv[i] = 'X';
				best = std::min(best, minimax(board, depth + 1, !maximizer));
				bv[i] = ' ';
			}
		}
		return best;
	}
}

int findBestMove(char bv[])
{
	int bestMoveScore = INT_MIN;
	int bestMove = -1;
	for (int i = 0; i < 9; ++i)
	{
		if (bv[i] == ' ')
		{
			bv[i] = 'O';
			int moveEval = minimax(bv, 0, false);
			bv[i] = ' ';

			if (moveEval > bestMoveScore)
			{
				bestMove = i;
				bestMove = moveEval;
			}
		}
	}

	return bestMove;
}

int main()
{
	while (gameOver == -1)
	{
		updateBoard(board, boardValues);
		printBoard(board, boardSize);

		int move = -1;
		while (move == -1)
		{
			if (ai && !Xturn)
			{
				move = findBestMove(boardValues);
			}
			else
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
		}

		char c = 79 + 9 * Xturn;
		boardValues[move] = c;
		Xturn = !Xturn;

		gameOver = checkGameOver(boardValues);
	}

	if (gameOver == 0)
	{
		cout << "\nDraw\n";
	}
	else if (gameOver == 1)
	{
		cout << "\nX Wins\n";
	}
	else if (gameOver == 2)
	{
		cout << "\nO Wins\n";
	}

	updateBoard(board, boardValues);
	printBoard(board, boardSize);
	cout << "Game Over";
}
