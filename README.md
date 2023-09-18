# Log Search Demo - Alex Teske

This project demonstrates a simple log search system. The current implementation allows a user to search within log files in /var/logs on the server's file system.

The project has been implemented in Ruby on Rails 7.0.8 and tested on a Windows platform.

## Installing/running the project

To run, you will need Ruby and Rails installed.

Setup:
```
bundle install
```

Run:
```
rails start
```

Test:
```
rails test
```

For the service to return any results, you will need log/text files in the server's /var/logs directory

## Usage (front-end and api)

The web service exposes two endpoints:

- **[GET] /logs**: Endpoint used by the front-end web client. Serves an HTML page with a form for submitting queries, and displays the result. In your web browser, visit "localhost:3000" or "localhost:3000/logs"
- **[GET] /logs/search**: Endpoint used by API clients. Returns a JSON object representing the search results. The parameters are:
    - **file_name (required)**: The name of the file to search within
    - **search_string (optional)**: A keyword to search for within the logs 
    - **limit (optional)**: The maximum number of log entries to return (default 10, maximum 1000)
    - **page (optional)**: The page number of results to return, each page contains *limit* results (default 1)

## Key Classes

The following are the key classes for the application, each of which are supported by unit tests:

- **LogsController**: Implements the endpoints described above
- **LogSearcher**: Main service class for the application. Responsible for performing the log file searches
- **LogSearcherParameters**: Encapsulates and valiadates the parameters for the search operation
- **FileLazyReverseLineReader**: Contains the logic for reading a file line-by-line in reverse order. For better performance (especially on larger files), the data is lazily read in chunks
