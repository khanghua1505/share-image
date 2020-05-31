Qt.include("consts.js")

function buttonClass(classNames) {
    let type = {
        style: buttonStyles.default,
        size: buttonSizes.default
    };
    
    for (const _class of classNames.split(' ')) {
        let className = _class.trim();
        let size = buttonSizes[className];
        let style = buttonStyles[className];
        if (size)
            type.size = size;
        if (style) 
            type.style = style;
    }
    
    return type;
}

var buttonColor = "#222";
var buttonBlockMargin = 10;
var buttonClearPadding = 6;
var ButtonBorderWidth = 1;
var ButtonBorderRadius = 5;

var buttonSizes = {
    default: {
        fontSize: 16,
        height: 42,
        padding: 12,
        iconSize: 24
    },
    
    large: {
        fontSize: 20,
        height: 54,
        padding: 16,
        iconSize: 32
    },
    
    small: {
        fontSize: 12,
        height: 28,
        padding: 4,
        iconSize: 16
    },
    
    bar: {
        fontSize: 13,
        height: 32,
        padding: 8,
        iconSize: 20
    }
};

var buttonStyles = {
    default: {
        background: color.stable,
        text: "#444",
        border: "#b2b2b2",
        activeBackground: "#e5e5e5",
        activeBorder: "#a2a2a2"
    },
    
    light: {
        background: color.light,
        text: "#444",
        border: "#ddd",
        activeBackground: "#fafafa",
        activeBorder: "#ccc"
    },
    
    stable: {
        background: color.stable,
        text: "#444",
        border: "#b2b2b2",
        activeBackground: "#e5e5e5",
        activeBorder: "#a2a2a2"
    },
    
    positive: {
        background: color.positive,
        text: "#fff",
        border: Qt.darker(color.positive, 1.18),
        activeBackground: Qt.darker(color.positive, 1.18),
        activeBorder: Qt.darker(color.positive, 1.18)
    },

    calm: {
        background: color.calm,
        text: "#fff",
        border: Qt.darker(color.calm, 1.18),
        activeBackground: Qt.darker(color.calm, 1.18),
        activeBorder: Qt.darker(color.calm, 1.18)
    },

    assertive: {
        background: color.assertive,
        text: "#fff",
        border: Qt.darker(color.assertive, 1.18),
        activeBackground: Qt.darker(color.assertive, 1.18),
        activeBorder: Qt.darker(color.assertive, 1.18)
    },

    dark: {
        background: color.dark,
        text: "#fff",
        border: Qt.darker(color.dark, 1.18),
        activeBackground: Qt.darker(color.dark, 1.18),
        activeBorder: Qt.darker(color.dark, 1.18)
    },

    balanced: {
        background: color.balanced,
        text: "#fff",
        border: Qt.darker(color.balanced, 1.18),
        activeBackground: Qt.darker(color.balanced, 1.18),
        activeBorder: Qt.darker(color.balanced, 1.18)
    },

    energized: {
        background: color.energized,
        text: "#fff",
        border: Qt.darker(color.energized, 1.18),
        activeBackground: Qt.darker(color.energized, 1.18),
        activeBorder: Qt.darker(color.energized, 1.18)
    },

    royal: {
        background: color.royal,
        text: "#fff",
        border: Qt.darker(color.royal, 1.18),
        activeBackground: Qt.darker(color.royal, 1.18),
        activeBorder: Qt.darker(color.royal, 1.18)
    },
};
