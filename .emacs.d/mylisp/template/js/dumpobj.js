for (var property in %s) {
    if (%s.hasOwnProperty(property)) {
        if (typeof %s[property] === 'function') {
            console.log(property, ':', %s[property]);
        }
    }
}