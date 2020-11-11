import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
import matplotlib.patches as patches
import pandas as pd
import numpy as np
from matplotlib.ticker import (MultipleLocator)
from matplotlib.backends.backend_pdf import PdfPages
import argparse
import fnmatch
import os


""" Global Properties ---------------------------------------------------------------------------------------------- """
def getFontProperties(folderName, fname, fontSize):
    """
    Utility function that helps loading fonts
    :param folderName: folder name
    :param fname: file name
    :param fontSize: matplotlib font size
    :return: matplotlib font properties instance
    """
    curr_cwd = os.getcwd()
    font_path = os.path.join(curr_cwd, 'fonts', folderName, fname)
    return fm.FontProperties(fname=font_path, size=fontSize)

# load fonts
sarabunFont = getFontProperties('Sarabun', 'Sarabun-Regular.ttf', 8)
sarabunFontTable = getFontProperties('Sarabun', 'Sarabun-Regular.ttf', 7)
sarabunFontSmall = getFontProperties('Sarabun', 'Sarabun-Regular.ttf', 6)
sarabunFontSemiBold = getFontProperties('Sarabun', 'Sarabun-SemiBold.ttf', 8)


""" FNS ------------------------------------------------------------------------------------------------------------ """
def getProjectInfo(constDataStr):
    """
    Extracting project information from a formatted given string
    :param constDataStr: input string
    :return: a dictionary containing project information
    """
    constData = constDataStr[2: -1]  # remove '#' and '\n' at the beginning and the end of text
    constData = constData.split(',')
    projectInformation = {
        'columnName': constData[0],
        'cementPerSoil': constData[1],
        'waterPerCement': constData[2],
        'maxDepth': constData[3],
        'projectName': constData[4],
        'projectOwnerName': constData[5],
        'projectContractorName': constData[6],
        'samplingRate': constData[7]
    }

    return projectInformation

def writeProjectInfo(ax, projectInfo, date, totalCementAmount, fontFamily):
    """
    Write project info at the head of the frame
    :param ax: matplotlib axes instance
    :param projectInfo: a dictionary containing project information
    :param date:
    :param totalCementAmount:
    :param fontFamily:
    :return: none
    """
    # Text Corrdinates
    x0 = 0.02; x1 = 0.40; x2 = 0.70
    y0 = 0.97; y1 = 0.95; y2 = 0.93

    # draw text
    ax.text(x=x0, y=y0, s='ชื่อโครงการ: ' + projectInfo['projectName'], fontproperties=fontFamily)
    ax.text(x=x1, y=y0, s='วันที่: ' + date, fontproperties=fontFamily)
    ax.text(x=x2, y=y0, s='จำนวนปูนที่ใช้ [กิโลกรัม]: ' + str(totalCementAmount), fontproperties=fontFamily)
    ax.text(x=x0, y=y1, s='เจ้าของโครงการ: ' + projectInfo['projectOwnerName'], fontproperties=fontFamily)
    ax.text(x=x1, y=y1, s='เสาเลขที่: ' + projectInfo['columnName'], fontproperties=fontFamily)
    ax.text(x=x2, y=y1, s='อัตราส่วนผสม W/C: ' + projectInfo['waterPerCement'], fontproperties=fontFamily)
    ax.text(x=x0, y=y2, s='ผู้รับจ้าง: ' + projectInfo['projectContractorName'], fontproperties=fontFamily)

def drawFrame():
    """
    Draw an outer frame with border
    :return: _frame/ matplotlib frame instance, axe/ matplotlib axe instance
    """
    paper_width = 8.3
    paper_height = 11.7
    axe_xmax = 1
    axe_ymax = 1

    # create figure
    _frame = plt.figure(figsize=[paper_width, paper_height])  # A4 size (inches)
    axe = _frame.add_axes([0, 0, axe_xmax, axe_ymax])

    # axes coordinates: (0, 0) is bottom left and (1, 1) is upper right
    p = patches.Rectangle(
        xy=(0.01 * axe_xmax, 0.01 * axe_ymax),
        width=0.98 * axe_xmax,
        height=0.98 * axe_ymax,
        alpha=1,
        linewidth=1,
        facecolor='none',
        edgecolor='black'
    )
    axe.add_patch(p)
    axe.set_axis_off()

    return _frame, axe

def calcXMaxLim(dataLen, portion):
    """
    Calculate maximum x-axis limit
    :param dataLen: number of data
    :param portion: number of portion
    :return: maximum value of x-axis limitation
    """
    return ((dataLen // portion) + 1) * portion

def calcYMultLocator(numDataPoints, numSamples):
    """
    Caculate the multiple locator of y-axis
    :param numDataPoints: number of all data points
    :param numSamples: number of sample to skip
    :return: number of multiple locator
    """
    return int(np.ceil(numDataPoints // numSamples))

def drawGraph(axBoilerplate, data, timestamps, axePos, x_label, lineStyle='-', lineColor='black', xticks_pad=0, multLocator=2, labelFontSize=6):
    """
    Graph drawing function which relies on the boiler plate axes instance
    :param axBoilerplate:
    :param data:
    :param timestamps:
    :param axePos:
    :param x_label:
    :param lineStyle:
    :param lineColor:
    :param xticks_pad:
    :param multLocator:
    :param labelFontSize:
    :return:
    """

    # calculate max lim
    x_max = calcXMaxLim(data.max(), 8)

    _ax = axBoilerplate.twiny()
    _ax.set_position(axePos)
    _ax.tick_params(axis='x', which='major', labelsize=labelFontSize, pad=xticks_pad)
    line, = _ax.plot(data, timestamps, ls=lineStyle, c=lineColor, linewidth=0.7)
    _ax.yaxis.set_major_locator(MultipleLocator(multLocator))
    _ax.xaxis.set_major_locator(MultipleLocator(x_max/8))
    _ax.set_xlabel(xlabel=x_label, loc='right', fontproperties=sarabunFontSmall)
    _ax.set_xlim([0, x_max])

    return _ax, line

def createBoilerplateGraph(ax, data, timestamps, axePos, x_label, lineStyle='-', lineColor='black', multLocator=2, timestampFontSize=6, labelFontSize=6):
    """
    Boilerplate for graph drawing
    :param ax: matplotlib axes instance
    :param data: series of data to plot
    :param timestamps:
    :param axePos:
    :param x_label:
    :param lineStyle:
    :param lineColor:
    :param multLocator:
    :param timestampFontSize:
    :param labelFontSize:
    :return: ax/ matplotlib axes instance, line/ matplotlib line instance
    """
    x_max = calcXMaxLim(data.max(), 8)

    # plot
    ax.set_position(axePos)
    line, = ax.plot(data, timestamps[::-1], ls=lineStyle, c=lineColor, linewidth=0.7)
    ax.yaxis.set_major_locator(MultipleLocator(multLocator))
    ax.tick_params(axis='y', which='major', labelsize=timestampFontSize)
    ax.tick_params(axis='x', which='both', labelsize=labelFontSize)
    ax.set_xlim([0, x_max])
    ax.set_xlabel(xlabel=x_label, loc='right', fontproperties=sarabunFontSmall)
    ax.set_ylim([timestamps[0], timestamps[-1]])

    # turn on grid
    ax.grid(color=(0.90, 0.90, 0.90), linestyle='dotted')

    return ax, line

def genOneReport(fpath, colorized=False, show=False):
    """
    Report generation routine
    :param fpath: Path of the .csv source file
    :param colorized: colorized flag
    :param show: show flag, shows plot in a new window (program will hang until user closes the window)
    :return: frame/ matplotlib frame instance, projectInfo/ a dictionary containing project information
    """
    # get constants from file
    with open(fpath) as file:
        constDataRaw = file.readline()
    file.close()

    projectInfo = getProjectInfo(constDataRaw)

    # load csv data
    csv = pd.read_csv(fpath, skiprows=1) # skip constants row

    # extract data by column
    time_series = csv.loc[:, 'time']
    date_series = csv.loc[:, 'date']
    depths = csv.loc[:, 'depth']
    drills = csv.loc[:, 'drill']
    pressures = csv.loc[:, 'pressure']
    strokes = csv.loc[:, 'stroke']
    wcs = csv.loc[:, 'wc']
    cementAmounts = csv.loc[:, 'cementAmount']
    flowRates = csv.loc[:, 'flowRate']


    # get time series with no ms
    time_series_no_ms = []
    for i in range(0, time_series.shape[0]):
        time, ms = time_series.iloc[i].split('.')
        time_series_no_ms.append(time)

    # draw outer frame
    frame, axe = drawFrame()
    writeProjectInfo(axe,
                     projectInfo,
                     date_series[0],
                     round(cementAmounts.iloc[-1], 2),
                     sarabunFontSemiBold)  # write project info

    # create 2 plots
    ax_graph, ax_data = frame.subplots(1, 2, sharey=True)

    # set position of the plots
    left_axe_pos = [0.07, 0.05, 0.45, 0.8]
    right_axe_pos = [0.55, 0.05, 0.4, 0.8]
    ax_graph.set_position(left_axe_pos)
    ax_data.set_position(right_axe_pos)

    # colorized graph
    line_colors = ['black', 'black', 'black', 'black']
    if colorized:
        line_colors = ['red', 'orange', 'green', 'blue']

    # draw graphs
    multLoc = calcYMultLocator(depths.shape[0], 50)
    ax_graph, depth_line                     = createBoilerplateGraph(ax_graph,
                                                                      depths,
                                                                      time_series_no_ms,
                                                                      left_axe_pos,
                                                                      'ความลึก[เมตร]',
                                                                      '-.',
                                                                      line_colors[0],
                                                                      multLocator=multLoc)

    ax_graph_pressure, pressure_line         = drawGraph(ax_graph,
                                                         pressures,
                                                         time_series_no_ms,
                                                         left_axe_pos,
                                                         'ความดัน[บาร์]',
                                                         '-',
                                                         line_colors[1],
                                                         multLocator=multLoc)

    ax_graph_flowRate, flowRate_line         = drawGraph(ax_graph,
                                                         flowRates,
                                                         time_series_no_ms,
                                                         left_axe_pos,
                                                         'อัตราการไหล[ลิตร/นาที]',
                                                         '--',
                                                         line_colors[2],
                                                         17,
                                                         multLoc)

    ax_graph_cementAmount, cementAmount_line = drawGraph(ax_graph,
                                                         cementAmounts,
                                                         time_series_no_ms,
                                                         left_axe_pos,
                                                         'ปริมาณซีเมนต์[กิโลกรัม]',
                                                         ':',
                                                         line_colors[3],
                                                         34,
                                                         multLoc)

    plt.legend([depth_line, flowRate_line, pressure_line, cementAmount_line],
               ['ความลึก[เมตร]', 'อัตราการไหล[ลิตร/นาที]', 'ความดัน[บาร์]', 'ปริมาณซีเมนต์[กิโลกรัม]'],
               prop=sarabunFontSmall)

    # create ndarray of data
    table_h = depths.shape[0]
    allData = np.zeros((table_h, 4))
    allData[:, 0] = depths
    allData[:, 1] = flowRates
    allData[:, 2] = pressures
    allData[:, 3] = cementAmounts

    # calculate time-step for data plot
    timeStep_mult = int(1/(float(projectInfo['samplingRate'])/1000))          # time-step is calculated from sampling rate
    selectedData_table_h = int(depths.shape[0] // (multLoc * timeStep_mult))  # calculate height of selected data table
    selectedData = np.zeros((selectedData_table_h, 4))
    selectedData_str = np.zeros((selectedData_table_h, 4)).astype('str')

    # copy some data from all data table into a selected data table
    for i in range(selectedData_table_h):
        try:
            selectedData[i, :] = allData[i*multLoc*timeStep_mult, :]
        except:
            print("data copy error")
            continue

    # cast type to 2 decimal places string
    i_row = 0
    for row in selectedData:
        row = ["%.2f" % num for num in row]
        selectedData_str[i_row] = row
        i_row += 1


    # Table Plotting
    ax_data.axis('off')  # turn off axis of table
    dataTable = ax_data.table(selectedData_str,
                              bbox=[0, -0.004, 1.1, 1.035],
                              cellLoc='center',
                              colLabels=['ความลึก[เมตร]', 'อัตราการไหล[ลิตร/นาที]', 'ความดัน[บาร์]', 'ปริมาณซีเมนต์[กิโลกรัม]'],
                              edges='open')
    dataTable.auto_set_font_size(False)
    dataTable_prop = dataTable.properties()
    dataTable_cells = dataTable_prop['celld']  # get table cells

    # change font prop of each cell
    for cell in dataTable_cells:
        dataTable_cells[cell].set_text_props(fontproperties=sarabunFontTable)

    if show:
        plt.gcf().canvas.set_window_title(projectInfo['columnName']) # set window title
        plt.show()

    return frame, projectInfo

def saveReport(fig, fpath, prefix_path="./", suffix_path=".pdf"):
    """
    Save report into files
    :param fig: matplotlib figure instance
    :param fpath: path to save the file
    :param prefix_path: prefix path
    :param suffix_path: file type
    :return: integer/ 0 success/ -1 error
    """
    try:
        savePath = os.path.join(prefix_path, fpath + suffix_path)
        with PdfPages(savePath) as pdf:
            pdf.savefig(fig)
        return 0
    except:
        return -1


def main():
    """
    Main program
    """

    # Arguments parsing
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true', help='see program working details')
    parser.add_argument('-c', '--colorized', action='store_true', help='colorize graph lines')
    args = parser.parse_args()

    #  find all csv files in ./records
    matches_files = []
    current_cwd = os.getcwd()
    record_dir = os.path.join(current_cwd, 'records')
    for root, dirnames, filenames in os.walk(record_dir):
        for filename in fnmatch.filter(filenames, '*.csv'):
            matches_files.append(os.path.join(root, filename))

    # find the corresponding pdf files
    for file in matches_files:
        pathHead = os.path.split(file)[0]
        pathTail = os.path.split(file)[1]
        fname = pathTail.split('.')[0]
        fpath_pdf = os.path.join(pathHead, fname + ".pdf")

        if os.path.exists(fpath_pdf):
            # pdf file existed
            if args.verbose:
                print(fpath_pdf + " already generated.")
        else:
            # pdf file doesn't exist
            # gen_path = os.path.join(output_dir, fname)
            print("Generating " + fname + ".csv")
            frame, projInfo = genOneReport(file, colorized=args.colorized)

            saveReport(frame, fname, prefix_path=pathHead)


if __name__ == '__main__':
    main()


