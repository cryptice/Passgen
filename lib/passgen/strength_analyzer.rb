module Passgen
  class StrengthAnalyzer
    MIN_LENGTH = 8
    attr_reader :password, :score, :complexity, :errors

    def initialize(pw)
      @password   = pw
      @score      = 0
      @complexity = "Invalid"
      @errors     = []
    end

    def self.analyze(pw)
      sa = StrengthAnalyzer.new(pw)
      sa.analyze
      sa
    end

    def analyze
      return self unless check_minimum_requirements

      nScore              = 0
      nLength             = 0
      nAlphaUC            = 0
      nAlphaLC            = 0
      nNumber             = 0
      nSymbol             = 0
      nMidChar            = 0
      nRequirements       = 0
      nAlphasOnly         = 0
      nNumbersOnly        = 0
      nUnqChar            = 0
      nRepChar            = 0
      nRepInc             = 0
      nConsecAlphaUC      = 0
      nConsecAlphaLC      = 0
      nConsecNumber       = 0
      nConsecSymbol       = 0
      nConsecCharType     = 0
      nSeqAlpha           = 0
      nSeqNumber          = 0
      nSeqSymbol          = 0
      nSeqChar            = 0
      nReqChar            = 0
      nMultConsecCharType = 0
      nMultRepChar        = 1
      nMultConsecSymbol   = 1
      nMultMidChar        = 2
      nMultRequirements   = 2
      nMultConsecAlphaUC  = 2
      nMultConsecAlphaLC  = 2
      nMultConsecNumber   = 2
      nReqCharType        = 3
      nMultAlphaUC        = 3
      nMultAlphaLC        = 3
      nMultSeqAlpha       = 3
      nMultSeqNumber      = 3
      nMultSeqSymbol      = 3
      nMultLength         = 4
      nMultNumber         = 4
      nMultSymbol         = 6
      nTmpAlphaUC         = ""
      nTmpAlphaLC         = ""
      nTmpNumber          = ""
      nTmpSymbol          = ""
      sAlphas             = 'abcdefghijklmnopqrstuvwxyz'
      sNumerics           = '01234567890'
      sSymbols            = '!@#$%&/()+?*'
      sComplexity         = 'Invalid'
      sStandards          = 'Below'
      nMinPwdLen          = MIN_LENGTH

      nScore    = @password.length * nMultLength
      nLength   = @password.length
      arrPwd    = @password.gsub(/\s+/, "").split(/\s*/)
      arrPwdLen = arrPwd.length

      # Loop through password to check for Symbol, Numeric, Lowercase and Uppercase pattern matches
      arrPwdLen.times do |a|
        if /[A-Z]/.match(arrPwd[a])
          if nTmpAlphaUC != ""
            if (nTmpAlphaUC + 1) == a
              nConsecAlphaUC  += 1
              nConsecCharType += 1
            end
          end
          nTmpAlphaUC = a
          nAlphaUC    += 1
        elsif /[a-z]/.match(arrPwd[a])
          if nTmpAlphaLC != ""
            if (nTmpAlphaLC + 1) == a
              nConsecAlphaLC  += 1
              nConsecCharType += 1
            end
          end
          nTmpAlphaLC = a
          nAlphaLC    += 1
        elsif /[0-9]/.match(arrPwd[a])
          if a > 0 && a < (arrPwdLen - 1)
            nMidChar += 1
          end
          if nTmpNumber != ""
            if (nTmpNumber + 1) == a
              nConsecNumber   += 1
              nConsecCharType += 1
            end
          end
          nTmpNumber = a
          nNumber    += 1
        elsif /[^a-zA-Z0-9_]/.match(arrPwd[a])
          if a > 0 && a < (arrPwdLen - 1)
            nMidChar += 1
          end
          if nTmpSymbol != ""
            if (nTmpSymbol + 1) == a
              nConsecSymbol   += 1
              nConsecCharType += 1
            end
          end
          nTmpSymbol = a;
          nSymbol += 1;
        end

        # Internal loop through password to check for repeat characters
        bCharExists = false
        arrPwdLen.times do |b|
          if arrPwd[a] == arrPwd[b] && a != b # repeat character exists
            bCharExists = true
            # Calculate increment deduction based on proximity to identical characters
            # Deduction is incremented each time a new match is discovered
            # Deduction amount is based on total password length divided by the
            # difference of distance between currently selected match
            nRepInc += (arrPwdLen / (b - a)).abs
          end
        end
        if bCharExists
          nRepChar += 1
          nUnqChar = arrPwdLen - nRepChar;
          nRepInc = (nUnqChar > 0) ? (nRepInc / nUnqChar).ceil : nRepInc.ceil
        end
      end

      # Check for sequential alpha string patterns (forward and reverse)
      (sAlphas.size - 3).times do |s|
        sFwd = sAlphas[s...s + 3]
        sRev = sFwd.reverse
        if @password.downcase.index(sFwd) || @password.downcase.index(sRev)
          nSeqAlpha += 1
          nSeqChar  += 1
        end
      end

      # Check for sequential numeric string patterns (forward and reverse)
      (sNumerics.size - 3).times do |s|
        sFwd = sNumerics[s...s + 3]
        sRev = sFwd.reverse
        if @password.downcase.index(sFwd) || @password.downcase.index(sRev)
          nSeqNumber += 1
          nSeqChar   += 1
        end
      end

      # Check for sequential symbol string patterns (forward and reverse)
      (sSymbols.size - 3).times do |s|
        sFwd = sSymbols[s...s + 3]
        sRev = sFwd.reverse
        if @password.downcase.index(sFwd) || @password.downcase.index(sRev)
          nSeqSymbol += 1
          nSeqChar   += 1
        end
      end

      # Modify overall score value based on usage vs requirements
      if nAlphaUC > 0 && nAlphaUC < nLength
        nScore += (nLength - nAlphaUC) * 2
      end

      if nAlphaLC > 0 && nAlphaLC < nLength
        nScore += (nLength - nAlphaLC) * 2
      end

      if nNumber > 0 && nNumber < nLength
        nScore += nNumber * nMultNumber
      end

      if nSymbol > 0
        nScore += nSymbol * nMultSymbol
      end

      if nMidChar > 0
        nScore += nMidChar * nMultMidChar
      end

      # Point deductions for poor practices
      if (nAlphaLC > 0 || nAlphaUC > 0) && nSymbol == 0 && nNumber == 0 # Only Letters
        nScore      -= nLength
        nAlphasOnly = nLength
      end

      if nAlphaLC === 0 && nAlphaUC === 0 && nSymbol === 0 && nNumber > 0 # Only Numbers
        nScore       -= nLength
        nNumbersOnly = nLength
      end

      if nRepChar > 0 # Same character exists more than once
        nScore -= nRepInc
      end

      if nConsecAlphaUC > 0 # Consecutive Uppercase Letters exist
        nScore -= nConsecAlphaUC * nMultConsecAlphaUC
      end

      if nConsecAlphaLC > 0 # Consecutive Lowercase Letters exist
        nScore -= nConsecAlphaLC * nMultConsecAlphaLC
      end

      if nConsecNumber > 0 # Consecutive Numbers exist
        nScore -= nConsecNumber * nMultConsecNumber
      end

      if nSeqAlpha > 0 # Sequential alpha strings exist (3 characters or more)
        nScore -= nSeqAlpha * nMultSeqAlpha
      end

      if nSeqNumber > 0 # Sequential numeric strings exist (3 character or more)
        nScore -= nSeqNumber * nMultSeqNumber
      end

      if nSeqSymbol > 0 # Sequential symbol strings exist (3 character or more)
        nScore -= nSeqSymbol * nMultSeqSymbol
      end

      # Determine if mandatory requirements have been met and set image indicators accordingly
      arrChars    = [nLength, nAlphaUC, nAlphaLC, nNumber, nSymbol]
      arrCharsIds = ["nLength", "nAlphaUC", "nAlphaLC", "nNumber", "nSymbol"]
      arrCharsLen = arrChars.length;
      arrCharsLen.times do |c|
        minVal = arrCharsIds[c] == "nLength" ? MIN_LENGTH - 1 : 0
        if arrChars[c] == (minVal + 1)
          nReqChar += 1
        elsif arrChars[c] > (minVal + 1)
          nReqChar += 1
        end
      end
      nRequirements = nReqChar
      nMinReqChars  = @password.length >= nMinPwdLen ? 3 : 4
      if nRequirements > nMinReqChars # One or more required characters exist
        nScore += (nRequirements * 2)
      end

      # Determine complexity based on overall score
      if nScore > 100
        nScore = 100
      elsif nScore < 0
        nScore = 0
      end
      @complexity = case nScore
                    when 0...20
                      "Trivial"
                    when 20...40
                      "Weak"
                    when 40...60
                      "Good"
                    when 60...80
                      "Strong"
                    else
                      "Very Strong"
                    end

      @score = nScore
    end

    private

    def check_minimum_requirements
      if @password.length < MIN_LENGTH
        @errors << "Password must be at least #{MIN_LENGTH} characters long"
        return false
      end
      true
    end
  end
end