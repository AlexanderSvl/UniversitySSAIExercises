#include <iostream>
#include <vector>
#include <cmath>
#include <numeric>
#include <iomanip>
#include <algorithm>

using namespace std;

vector<int> x = { 11, 21, 58, 43, 13, 24, 59, 54, 20, 57, 49, 23, 25, 50, 42, 21, 47, 9, 8, 11 };
vector<int> y = { 46, 48, 4, 22, 56, 39, 32, 10, 43, 7, 38, 12, 37, 29, 24 };  
vector<int> z = { 35, 58, 79, 62, 67, 88, 55, 79, 87, 67, 50, 68, 74, 64, 85 };  

double mean(const vector<int>& data) {
    return accumulate(data.begin(), data.end(), 0.0) / data.size();
}

double variance(const vector<int>& data, double mean) {
    double sum = 0.0;
    for (double val : data) {
        sum += (val - mean) * (val - mean);
    }
    return sum / data.size();
}

double standardDeviation(double variance) {
    return sqrt(variance);
}

double correlationCoefficient(const vector<int>& dataX, const vector<int>& dataZ) {
    int n = min(dataX.size(), dataZ.size());
    double meanX = mean(dataX);
    double meanZ = mean(dataZ);

    double numerator = 0.0;
    double sumSquaresX = 0.0;
    double sumSquaresZ = 0.0;

    for (size_t i = 0; i < n; ++i) {
        double diffX = dataX[i] - meanX;
        double diffZ = dataZ[i] - meanZ;
        numerator += diffX * diffZ;
        sumSquaresX += diffX * diffX;
        sumSquaresZ += diffZ * diffZ;
    }

    double standardDevX = sqrt(sumSquaresX / (n - 1));
    double standardDevZ = sqrt(sumSquaresZ / (n - 1));

    return numerator / ((n - 1) * standardDevX * standardDevZ);
}


pair<double, double> confidenceInterval(double mean, double stdDev, int n, double zScore = 1.96) {
    double marginOfError = zScore * (stdDev / sqrt(n));
    return { mean - marginOfError, mean + marginOfError };
}

int main() {
    double meanX = mean(x);
    double meanY = mean(y);
    double meanZ = mean(z);

    double varianceX = variance(x, meanX);
    double varianceY = variance(y, meanY);
    double varianceZ = variance(z, meanZ);

    double stdDevX = standardDeviation(varianceX);
    double stdDevY = standardDeviation(varianceY);
    double stdDevZ = standardDeviation(varianceZ);

    double corrXZ = correlationCoefficient(x, z);

    auto ciMeanX = confidenceInterval(meanX, stdDevX, x.size());
    auto ciVarianceX = confidenceInterval(varianceX, stdDevX, x.size());

    cout << fixed << setprecision(2);
    cout << "Mean of X: " << meanX << endl;
    cout << "Mean of Y: " << meanY << endl;
    cout << "Mean of Z: " << meanZ << endl;

    cout << "\nVariance of X: " << varianceX << endl;
    cout << "Variance of Y: " << varianceY << endl;
    cout << "Variance of Z: " << varianceZ << endl;

    cout << "\nStandard Deviation of X: " << stdDevX << endl;
    cout << "Standard Deviation of Y: " << stdDevY << endl;
    cout << "Standard Deviation of Z: " << stdDevZ << endl;

    cout << "\nCorrelation Coefficient between X and Z: " << corrXZ << endl;

    cout << "\nConfidence Interval for Mean of X: (" << ciMeanX.first << ", " << ciMeanX.second << ")" << endl;
    cout << "Confidence Interval for Variance of X: (" << ciVarianceX.first << ", " << ciVarianceX.second << ")" << endl;

    return 0;
}