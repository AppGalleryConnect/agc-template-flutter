enum Breakpoint {
  sm,
  md,
  lg,
  xl,
}

extension BreakpointExtension on Breakpoint {
  int get lanes {
    switch (this) {
      case Breakpoint.sm:
        return 1;
      case Breakpoint.md:
        return 2;
      case Breakpoint.lg:
      case Breakpoint.xl:
        return 3;
    }
  }

  static Breakpoint fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sm':
        return Breakpoint.sm;
      case 'md':
        return Breakpoint.md;
      case 'lg':
        return Breakpoint.lg;
      case 'xl':
        return Breakpoint.xl;
      default:
        throw ArgumentError('非法断点值');
    }
  }
}
