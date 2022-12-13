#include <iostream>
#include <algorithm>
#include<limits>

extern "C" void asmMain();

using std::cout;
using std::cin;

char boardValues[] = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' };
char board[] = { ' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ',' ',' ','|',' ',' ',' ','|',' ',' ','\n','\n' };
char boardTutorial[] = { ' ','0',' ','|',' ','1',' ','|',' ','2','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ','3',' ','|',' ','4',' ','|',' ','5','\n','-','-','-','+','-','-','-','+','-','-','-','\n',' ','6',' ','|',' ','7',' ','|',' ','8','\n','\n' };
bool Xturn = true;
int gameOver = -1;
bool ai = true;
bool assembly = true;

extern "C" int getInput()
{
	int move = 0;
	cout << "Enter Move (0-8): ";
	while (!(cin >> move))
	{
		cin.clear();
		cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		cout << "Invalid input\n\nEnter Move (0-8): ";
	}
	return move;
}

extern "C" int queryAI()
{
	int move = 0;
	cout << "Vs AI? (1 or 0): ";
	while (!(cin >> move))
	{
		cin.clear();
		cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		cout << "Invalid input\n\nVs AI? (1 or 0): ";
	}
	return move;
}

extern "C" void printString(char* s)
{
	cout << s;
}

// 1, 5, 9
// 24, 28, 32
// 47, 51, 55
void updateBoard(char b[], char bv[])
{
	for (int i = 0; i < 9; ++i)
	{
		int index = (4 * i) + 1 + (11 * std::floor(i / 3));
		b[index] = bv[i];
	}
}

void updateTutorialBoard(char b[], char bv[])
{
	for (int i = 0; i < 9; ++i)
	{
		if (bv[i] != ' ')
		{
			int index = (4 * i) + 1 + (11 * std::floor(i / 3));
			b[index] = ' ';
		}
	}
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

// Returns:
// 0 = tie
// 1 = X wins
// 2 = O wins
// -1 = none
int checkGameOver(char bv[])
{
	for (int i = 0; i < 8; ++i)
	{
		if (checkLine(bv, i, 'X'))
			return 1;
		if (checkLine(bv, i, 'O'))
			return 2;
	}
	
	for (int i = 0; i < 9; ++i)
	{
		if (bv[i] == ' ')
			return -1;
	}

	return 0;
}

int minimax(char bv[], bool maximizer)
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

		for (int i = 8; i >= 0; --i)
		{
			if (bv[i] == ' ')
			{
				bv[i] = 'O';
				best = std::max(best, minimax(bv, !maximizer));
				bv[i] = ' ';
			}
		}
		return best;
	}
	else
	{
		int best = INT_MAX;

		for (int i = 8; i >= 0; --i)
		{
			if (bv[i] == ' ')
			{
				bv[i] = 'X';
				best = std::min(best, minimax(bv, !maximizer));
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
	for (int i = 8; i >= 0; --i)
	{
		if (bv[i] == ' ')
		{
			bv[i] = 'O';
			int moveEval = minimax(bv, false);
			bv[i] = ' ';

			if (moveEval > bestMoveScore)
			{
				bestMove = i;
				bestMoveScore = moveEval;
			}
		}
	}

	return bestMove;
}

int main()
{
	if (assembly)
	{
		asmMain();
	}
	else
	{
		int useAI = -1;
		while (useAI == -1)
		{
			useAI = queryAI();
			if (useAI < 0 || useAI > 1)
			{
				cout << "Please input 0 or 1\n";
				useAI = -1;
			}
		}
		ai = useAI;
		while (gameOver == -1)
		{
			int move = -1;
			while (move == -1)
			{
				if (ai && !Xturn)
				{
					move = findBestMove(boardValues);
				}
				else
				{
					updateTutorialBoard(boardTutorial, boardValues);
					printString(boardTutorial);
					updateBoard(board, boardValues);
					printString(board);

					move = getInput();
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

		updateBoard(board, boardValues);
		printString(board);

		if (gameOver == 0)
			cout << "Draw\n";
		else if (gameOver == 1)
			cout << "X Wins\n";
		else if (gameOver == 2)
			cout << "O Wins\n";
	}
	return 0;
}
