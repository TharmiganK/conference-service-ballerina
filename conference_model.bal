# Represents a conference
#
# + id - The id of the conference
# + name - The name of the conference
public type Conference record {|
    readonly int id;
    string name;
|};

# Represents a conference request
#
# + name - The name of the conference
public type ConferenceRequest record {|
    string name;
|};

# Represents a country response
#
# + name - The name of the country
public type Country record {|
    string name;
|};

# Represents a extended conference
#
# + name - The name of the conference
# + country - The country of the conference
public type ExtendedConference record {|
    string name;
    string country;
|};
