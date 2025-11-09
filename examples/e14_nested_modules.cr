# Test nested modules with classes
module E14::Services
  module Authentication
    class Authentication::User
      property email : String
      property password_hash : String

      def initialize(@email : String, @password_hash : String); end

      def authenticate(password : String) : Bool
        true
      end
    end

    class Authentication::Session
      property user : Authentication::User
      property token : String
      property expires_at : Time

      def initialize(@user : User, @token : String, @expires_at : Time); end

      def valid? : Bool
        Time.utc < @expires_at
      end
    end
  end

  module Database
    abstract class Database::Connection
      abstract def execute(query : String) : Void
      abstract def close : Void
    end

    class Database::PostgresConnection < Database::Connection
      property host : String
      property port : Int32

      def initialize(@host : String, @port : Int32 = 5432); end

      def execute(query : String) : Void
        puts "Executing: #{query}"
      end

      def close : Void
        puts "Closing connection"
      end
    end
  end
end
