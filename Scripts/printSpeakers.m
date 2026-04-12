function printSpeakers(nominal, intruder)
    % Print nominal names
    prevName = "";
        fprintf("Nominal Speakers: \n")
        while hasdata(nominal)
            [audio, data] = read(nominal);
            name = string(data.Label);
            if (name ~= prevName)
                prevName = name;
                fprintf("--%s \n", name)
            end
        end
        fprintf("\n")


    % Print Intruder names
    prevName = "";
        fprintf("Intruder Speakers: \n")
        while hasdata(intruder)
            [audio, data] = read(intruder);
            name = string(data.Label);
            if (name ~= prevName)
                prevName = name;
                fprintf("--%s \n", name)
            end
        end
        fprintf("\n")